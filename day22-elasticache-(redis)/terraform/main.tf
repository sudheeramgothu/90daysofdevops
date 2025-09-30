terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "aws" {
  region = var.region
}

# ----------------------
# Security Group: allow Redis 6379 from app SGs (preferred) or extra CIDRs
# ----------------------
resource "aws_security_group" "redis" {
  name        = "${var.name_prefix}-redis-sg"
  description = "Allow Redis from app security groups"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.app_security_group_ids
    content {
      description     = "Redis 6379 from app SG"
      from_port       = 6379
      to_port         = 6379
      protocol        = "tcp"
      security_groups = [ingress.value]
    }
  }

  dynamic "ingress" {
    for_each = var.extra_cidr_ingress
    content {
      description = "Redis 6379 from CIDR"
      from_port   = 6379
      to_port     = 6379
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.name_prefix}-redis-sg" })
}

# ----------------------
# Subnet Group (private)
# ----------------------
resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.name_prefix}-subnets"
  subnet_ids = var.private_subnet_ids

  tags = merge(var.tags, { Name = "${var.name_prefix}-subnets" })
}

# ----------------------
# (Optional) Parameter Group
# ----------------------
resource "aws_elasticache_parameter_group" "this" {
  count = length(var.parameter_overrides) > 0 ? 1 : 0

  name   = "${var.name_prefix}-params"
  family = var.redis_family

  dynamic "parameter" {
    for_each = var.parameter_overrides
    content {
      name  = parameter.key
      value = parameter.value
    }
  }
}

# ----------------------
# Auth token
# ----------------------
resource "random_password" "auth" {
  length  = 32
  special = false
}

locals {
  final_auth_token = var.auth_token != null && var.auth_token != "" ? var.auth_token : random_password.auth.result
}

# ----------------------
# Replication Group (cluster mode disabled by default)
# ----------------------
resource "aws_elasticache_replication_group" "this" {
  replication_group_id          = "${var.name_prefix}-rg"
  description                   = "Day 22 Redis replication group"
  engine                        = "redis"
  engine_version                = var.engine_version
  node_type                     = var.node_type
  port                          = 6379
  parameter_group_name          = length(var.parameter_overrides) > 0 ? aws_elasticache_parameter_group.this[0].name : null

  subnet_group_name             = aws_elasticache_subnet_group.this.name
  security_group_ids            = [aws_security_group.redis.id]

  at_rest_encryption_enabled    = true
  transit_encryption_enabled    = true
  auth_token                    = local.final_auth_token

  automatic_failover_enabled    = var.automatic_failover_enabled
  multi_az_enabled              = var.multi_az_enabled

  # Cluster mode disabled: use num_cache_clusters for N replicas across AZs
  num_cache_clusters            = var.cluster_mode_enabled ? null : var.num_cache_clusters

  # Cluster mode enabled (sharded): configure shards/replicas
  dynamic "cluster_mode" {
    for_each = var.cluster_mode_enabled ? [1] : []
    content {
      num_node_groups         = var.num_node_groups
      replicas_per_node_group = var.replicas_per_node_group
    }
  }

  maintenance_window            = var.maintenance_window
  snapshot_retention_limit      = var.snapshot_retention_limit
  snapshot_window               = var.snapshot_window

  auto_minor_version_upgrade    = true

  tags = merge(var.tags, { Name = "${var.name_prefix}-rg" })
}

# ----------------------
# Outputs
# ----------------------
output "primary_endpoint_address" {
  value = aws_elasticache_replication_group.this.primary_endpoint_address
}

output "reader_endpoint_address" {
  value = aws_elasticache_replication_group.this.reader_endpoint_address
}

output "redis_sg_id" {
  value = aws_security_group.redis.id
}

output "subnet_group_name" {
  value = aws_elasticache_subnet_group.this.name
}

output "auth_token_note" {
  value = var.auth_token != null && var.auth_token != "" ? "Using provided auth_token" : "Auth token generated (refer to your state/variables management)"
}
