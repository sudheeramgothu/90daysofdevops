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
# Password handling
# ----------------------
resource "random_password" "db" {
  length           = 20
  special          = true
  override_characters = "!@#%^*-_=+,.?"
}

# If user provides db_password, prefer that; else use random.
locals {
  final_db_password = var.db_password != null && var.db_password != "" ? var.db_password : random_password.db.result
}

# Optional Secrets Manager storage
resource "aws_secretsmanager_secret" "db_credentials" {
  count = var.enable_secrets_manager ? 1 : 0
  name  = "${var.name_prefix}-db-credentials"
  tags  = var.tags
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  count     = var.enable_secrets_manager ? 1 : 0
  secret_id = aws_secretsmanager_secret.db_credentials[0].id
  secret_string = jsonencode({
    username = var.db_username
    password = local.final_db_password
    engine   = "postgres"
    host     = aws_db_instance.postgres.address
    port     = aws_db_instance.postgres.port
    dbname   = var.db_name
  })
}

# ----------------------
# DB Security Group
# ----------------------
resource "aws_security_group" "db" {
  name        = "${var.name_prefix}-db-sg"
  description = "Allow PostgreSQL from app security groups"
  vpc_id      = var.vpc_id

  # Ingress: allow 5432 from provided app SGs (preferred)
  dynamic "ingress" {
    for_each = var.app_security_group_ids
    content {
      description     = "PostgreSQL from app SG"
      from_port       = 5432
      to_port         = 5432
      protocol        = "tcp"
      security_groups = [ingress.value]
    }
  }

  # Optional: CIDR-based ingress (e.g., bastion/jump hosts). Disabled by default.
  dynamic "ingress" {
    for_each = var.extra_cidr_ingress
    content {
      description = "PostgreSQL from CIDR"
      from_port   = 5432
      to_port     = 5432
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

  tags = merge(var.tags, { Name = "${var.name_prefix}-db-sg" })
}

# ----------------------
# Subnet Group (private subnets from Day 14)
# ----------------------
resource "aws_db_subnet_group" "db" {
  name       = "${var.name_prefix}-db-subnets"
  subnet_ids = var.private_subnet_ids

  tags = merge(var.tags, { Name = "${var.name_prefix}-db-subnets" })
}

# ----------------------
# Parameter Group
# ----------------------
resource "aws_db_parameter_group" "pg" {
  name        = "${var.name_prefix}-pg"
  family      = var.parameter_group_family
  description = "Custom parameters for ${var.engine} ${var.engine_version}"

  dynamic "parameter" {
    for_each = var.db_parameters
    content {
      name  = parameter.key
      value = parameter.value
    }
  }

  tags = merge(var.tags, { Name = "${var.name_prefix}-pg" })
}

# ----------------------
# RDS Instance (PostgreSQL)
# ----------------------
resource "aws_db_instance" "postgres" {
  identifier                 = "${var.name_prefix}-postgres"
  engine                     = var.engine
  engine_version             = var.engine_version
  instance_class             = var.instance_class

  db_name                    = var.db_name
  username                   = var.db_username
  password                   = local.final_db_password

  multi_az                   = var.multi_az
  allocated_storage          = var.allocated_storage
  max_allocated_storage      = var.max_allocated_storage

  storage_encrypted          = true
  kms_key_id                 = var.kms_key_id

  db_subnet_group_name       = aws_db_subnet_group.db.name
  vpc_security_group_ids     = [aws_security_group.db.id]
  publicly_accessible        = false

  backup_retention_period    = var.backup_retention_days
  backup_window              = var.backup_window
  maintenance_window         = var.maintenance_window
  apply_immediately          = var.apply_immediately

  deletion_protection        = var.deletion_protection
  skip_final_snapshot        = var.skip_final_snapshot
  final_snapshot_identifier  = var.skip_final_snapshot ? null : "${var.name_prefix}-final-snapshot"

  performance_insights_enabled = var.enable_performance_insights
  performance_insights_kms_key_id = var.kms_key_id

  auto_minor_version_upgrade = true
  copy_tags_to_snapshot      = true
  parameter_group_name       = aws_db_parameter_group.pg.name

  tags = merge(var.tags, { Name = "${var.name_prefix}-postgres" })
}

# ----------------------
# Outputs
# ----------------------
output "db_endpoint" {
  value = aws_db_instance.postgres.address
}

output "db_port" {
  value = aws_db_instance.postgres.port
}

output "db_identifier" {
  value = aws_db_instance.postgres.id
}

output "db_parameter_group" {
  value = aws_db_parameter_group.pg.name
}

output "db_subnet_group" {
  value = aws_db_subnet_group.db.name
}

output "db_security_group_id" {
  value = aws_security_group.db.id
}

output "secret_arn" {
  value       = try(aws_secretsmanager_secret.db_credentials[0].arn, null)
  description = "Secrets Manager secret with DB credentials (if enable_secrets_manager=true)"
}
