terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  # Select the first az_count AZs
  azs = slice(data.aws_availability_zones.available.names, 0, var.az_count)

  # Derive subnet CIDRs from the VPC CIDR:
  # We allocate the first N for public, next N for private.
  public_subnet_cidrs  = [for i in range(var.az_count) : cidrsubnet(var.vpc_cidr, var.public_subnet_newbits, i)]
  private_subnet_cidrs = [for i in range(var.az_count) : cidrsubnet(var.vpc_cidr, var.private_subnet_newbits, i + var.az_count)]
}

# -------------------
# VPC + Internet Gateway
# -------------------
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(var.tags, { Name = "${var.name_prefix}-vpc" })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.name_prefix}-igw" })
}

# -------------------
# Public subnets (one per AZ)
# -------------------
resource "aws_subnet" "public" {
  for_each = { for idx, az in toset(local.azs) : idx => az }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = local.public_subnet_cidrs[tonumber(each.key)]
  availability_zone       = each.value
  map_public_ip_on_launch = true
  tags = merge(var.tags, {
    Name = "${var.name_prefix}-public-${each.value}"
    Tier = "public"
  })
}

# Public route table with default route to IGW
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.name_prefix}-public-rt" })
}

resource "aws_route" "public_igw" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# -------------------
# NAT Gateway(s) + EIP(s)
# -------------------
# If single_nat = true, create one NAT/EIP in the first public subnet; else one per AZ
resource "aws_eip" "nat" {
  for_each = var.single_nat ? { "0" = one(aws_subnet.public).id } : { for k, s in aws_subnet.public : k => s.id }
  domain   = "vpc"
  tags     = merge(var.tags, { Name = "${var.name_prefix}-nat-eip-${each.key}" })
}

resource "aws_nat_gateway" "this" {
  for_each = var.single_nat ? { "0" = one(aws_subnet.public) } : aws_subnet.public

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = each.value.id
  tags          = merge(var.tags, { Name = "${var.name_prefix}-nat-${each.key}" })
  depends_on    = [aws_internet_gateway.igw]
}

# -------------------
# Private subnets + route tables
# -------------------
resource "aws_subnet" "private" {
  for_each = { for idx, az in toset(local.azs) : idx => az }

  vpc_id            = aws_vpc.this.id
  cidr_block        = local.private_subnet_cidrs[tonumber(each.key)]
  availability_zone = each.value
  tags = merge(var.tags, {
    Name = "${var.name_prefix}-private-${each.value}"
    Tier = "private"
  })
}

# Private route tables: one per AZ to steer to the local NAT (or the single NAT)
resource "aws_route_table" "private" {
  for_each = aws_subnet.private

  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.name_prefix}-private-rt-${each.key}" })
}

# Route from private RT to NAT (choose NAT in same AZ for HA, or index 0 if single_nat)
resource "aws_route" "private_nat" {
  for_each = aws_route_table.private

  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.single_nat ? aws_nat_gateway.this["0"].id : aws_nat_gateway.this[each.key].id
}

resource "aws_route_table_association" "private_assoc" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}

# -------------------
# Outputs
# -------------------
output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = [for s in aws_subnet.public : s.id]
}

output "private_subnet_ids" {
  value = [for s in aws_subnet.private : s.id]
}

output "nat_gateway_ids" {
  value = [for n in aws_nat_gateway.this : n.id]
}

output "public_route_table_id" {
  value = aws_route_table.public.id
}
