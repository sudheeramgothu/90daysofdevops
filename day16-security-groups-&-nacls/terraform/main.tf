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

# ----------------------
# Security Groups (stateful)
# ----------------------

# Web SG: allow HTTP/HTTPS from anywhere, SSH from a specific CIDR; egress all
resource "aws_security_group" "web_sg" {
  name        = "${var.name_prefix}-web-sg"
  description = "Web tier ingress (80/443 from world, 22 from allowed CIDR)"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH (restricted)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.name_prefix}-web-sg" })
}

# DB SG: allow 5432 from web_sg by default (can be switched to app_sg in challenge)
resource "aws_security_group" "db_sg" {
  name        = "${var.name_prefix}-db-sg"
  description = "DB tier ingress (5432 from web/app)"
  vpc_id      = var.vpc_id

  ingress {
    description              = "PostgreSQL from web tier"
    from_port                = 5432
    to_port                  = 5432
    protocol                 = "tcp"
    security_groups          = [aws_security_group.web_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.name_prefix}-db-sg" })
}

# ----------------------
# NACLs (stateless) + Associations
# ----------------------

# PUBLIC NACL: allow inbound 80/443 + ephemeral, SSH inbound only from ssh_allowed_cidr; allow all egress
resource "aws_network_acl" "public" {
  vpc_id = var.vpc_id
  tags   = merge(var.tags, { Name = "${var.name_prefix}-public-nacl" })
}

# Ingress 100: allow HTTP
resource "aws_network_acl_rule" "public_ing_http" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

# Ingress 110: allow HTTPS
resource "aws_network_acl_rule" "public_ing_https" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 110
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

# Ingress 120: allow SSH from allowed CIDR
resource "aws_network_acl_rule" "public_ing_ssh" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 120
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = var.ssh_allowed_cidr
  from_port      = 22
  to_port        = 22
}

# Ingress 140: allow ephemeral responses
resource "aws_network_acl_rule" "public_ing_ephemeral" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 140
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

# Egress 100: allow all egress
resource "aws_network_acl_rule" "public_eg_all" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

# Associate PUBLIC NACL with all public subnets
resource "aws_network_acl_association" "public_assoc" {
  for_each       = toset(var.public_subnet_ids)
  network_acl_id = aws_network_acl.public.id
  subnet_id      = each.value
}

# PRIVATE NACL: allow only VPC-internal inbound (ephemeral), and all outbound
resource "aws_network_acl" "private" {
  vpc_id = var.vpc_id
  tags   = merge(var.tags, { Name = "${var.name_prefix}-private-nacl" })
}

# Ingress 100: allow ephemeral from VPC CIDR (responses to outbound)
resource "aws_network_acl_rule" "private_ing_ephemeral_from_vpc" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = var.vpc_cidr
  from_port      = 1024
  to_port        = 65535
}

# Egress 100: allow all egress from private subnets
resource "aws_network_acl_rule" "private_eg_all" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

# Associate PRIVATE NACL with all private subnets
resource "aws_network_acl_association" "private_assoc" {
  for_each       = toset(var.private_subnet_ids)
  network_acl_id = aws_network_acl.private.id
  subnet_id      = each.value
}

# ----------------------
# Outputs
# ----------------------

output "web_sg_id" {
  value = aws_security_group.web_sg.id
}

output "db_sg_id" {
  value = aws_security_group.db_sg.id
}

output "public_nacl_id" {
  value = aws_network_acl.public.id
}

output "private_nacl_id" {
  value = aws_network_acl.private.id
}
