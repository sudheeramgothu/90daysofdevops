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

# Endpoint Policies
data "aws_iam_policy_document" "s3_default_endpoint" {
  statement {
    actions   = ["*"]
    resources = ["*"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

locals {
  s3_endpoint_policy_doc      = var.s3_endpoint_policy_json != null ? var.s3_endpoint_policy_json : data.aws_iam_policy_document.s3_default_endpoint.json
  dynamodb_endpoint_policy_doc = var.dynamodb_endpoint_policy_json != null ? var.dynamodb_endpoint_policy_json : data.aws_iam_policy_document.s3_default_endpoint.json
}

# Gateway Endpoints
resource "aws_vpc_endpoint" "s3_gw" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.private_route_table_ids
  policy            = local.s3_endpoint_policy_doc
}

resource "aws_vpc_endpoint" "dynamodb_gw" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.private_route_table_ids
  policy            = local.dynamodb_endpoint_policy_doc
}

# Interface Endpoints
resource "aws_security_group" "vpce" {
  name        = "${var.name_prefix}-vpce-sg"
  description = "Allow HTTPS from VPC CIDR to Interface Endpoints"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

locals {
  interface_services = [
    "com.amazonaws.${var.region}.ssm",
    "com.amazonaws.${var.region}.ec2messages",
    "com.amazonaws.${var.region}.ssmmessages"
  ]
}

resource "aws_vpc_endpoint" "interface" {
  for_each            = toset(local.interface_services)
  vpc_id              = var.vpc_id
  service_name        = each.value
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [aws_security_group.vpce.id]
}
