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

resource "aws_kms_key" "config" {
  count                   = var.create_kms_key ? 1 : 0
  description             = "KMS for Param Store SecureString and Secrets for ${var.env}/${var.app_name}"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  tags                    = var.tags
}

resource "aws_kms_alias" "config" {
  count         = var.create_kms_key ? 1 : 0
  name          = "alias/${var.name_prefix}-${var.env}-${var.app_name}"
  target_key_id = aws_kms_key.config[0].key_id
}

locals {
  kms_arn = var.create_kms_key ? aws_kms_key.config[0].arn : var.kms_key_arn
  prefix  = "/${var.env}/${var.app_name}"
}

resource "aws_ssm_parameter" "plain" {
  for_each = var.parameters
  name        = "${local.prefix}/${each.key}"
  description = "Plain parameter ${each.key} for ${var.env}/${var.app_name}"
  type        = "String"
  value       = each.value
  overwrite   = true
  tags        = var.tags
}

resource "aws_ssm_parameter" "secure" {
  for_each = var.secure_parameters
  name        = "${local.prefix}/${each.key}"
  description = "Secure parameter ${each.key} for ${var.env}/${var.app_name}"
  type        = "SecureString"
  value       = each.value
  key_id      = local.kms_arn
  overwrite   = true
  tags        = var.tags
}

resource "random_password" "db" {
  length  = 20
  special = true
}

locals {
  final_db_password = var.db_password != null && var.db_password != "" ? var.db_password : random_password.db.result
  secret_name       = var.secret_name != "" ? var.secret_name : "${var.env}/${var.app_name}/db-credentials"
}

resource "aws_secretsmanager_secret" "db" {
  name       = local.secret_name
  kms_key_id = local.kms_arn
  tags       = var.tags
}

resource "aws_secretsmanager_secret_version" "db" {
  secret_id     = aws_secretsmanager_secret.db.id
  secret_string = jsonencode({
    username = var.db_username
    password = local.final_db_password
    host     = var.db_host
    port     = var.db_port
    engine   = "postgres"
    dbname   = var.db_name
  })
}

data "aws_iam_policy_document" "app_ssm_secrets_access" {
  statement {
    sid = "ParamStoreRead"
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParametersByPath",
      "ssm:DescribeParameters",
      "kms:Decrypt"
    ]
    resources = concat(
      [for k, _ in var.parameters : "arn:aws:ssm:${var.region}:${var.account_id}:parameter/${var.env}/${var.app_name}/${k}"],
      [for k, _ in var.secure_parameters : "arn:aws:ssm:${var.region}:${var.account_id}:parameter/${var.env}/${var.app_name}/${k}"],
      local.kms_arn != null ? [local.kms_arn] : ["arn:aws:kms:${var.region}:${var.account_id}:key/*"]
    )
  }

  statement {
    sid = "SecretsRead"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "kms:Decrypt"
    ]
    resources = [aws_secretsmanager_secret.db.arn]
  }
}

output "param_prefix" {
  value = local.prefix
}

output "secret_name" {
  value = aws_secretsmanager_secret.db.name
}

output "kms_key_arn" {
  value = local.kms_arn
}

output "app_access_policy_json" {
  value = data.aws_iam_policy_document.app_ssm_secrets_access.json
  description = "Attach this as inline policy to your app's instance/task role"
}
