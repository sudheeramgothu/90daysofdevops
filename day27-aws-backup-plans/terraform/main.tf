terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Primary region (backups run here)
provider "aws" {
  region = var.region
}

# Optional destination region for copy actions
provider "aws" {
  alias  = "dr"
  region = var.copy_to_region != null ? var.copy_to_region : var.region
}

data "aws_caller_identity" "current" {}

# ------------------------------
# Backup Vault (+ optional SNS)
# ------------------------------
resource "aws_backup_vault" "this" {
  name        = "${var.name_prefix}-vault"
  kms_key_arn = var.kms_key_arn
  tags        = var.tags
}

resource "aws_sns_topic" "backup" {
  count = var.enable_sns_notifications ? 1 : 0
  name  = "${var.name_prefix}-backup-events"
  tags  = var.tags
}

resource "aws_backup_vault_notifications" "this" {
  count              = var.enable_sns_notifications ? 1 : 0
  backup_vault_name  = aws_backup_vault.this.name
  sns_topic_arn      = aws_sns_topic.backup[0].arn
  backup_vault_events = ["BACKUP_JOB_COMPLETED","RESTORE_JOB_COMPLETED","BACKUP_JOB_FAILED","RESTORE_JOB_FAILED"]
}

# ------------------------------
# Service role for AWS Backup
# ------------------------------
data "aws_iam_policy_document" "assume_backup" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "backup" {
  name               = "${var.name_prefix}-backup-role"
  assume_role_policy = data.aws_iam_policy_document.assume_backup.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "backup_service" {
  role       = aws_iam_role.backup.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}

resource "aws_iam_role_policy_attachment" "restore_service" {
  role       = aws_iam_role.backup.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores"
}

# ------------------------------
# Backup Plan (daily rule + optional monthly rule + optional copy)
# ------------------------------
resource "aws_backup_plan" "this" {
  name = "${var.name_prefix}-plan"

  rule {
    rule_name         = "daily-35d"
    target_vault_name = aws_backup_vault.this.name
    schedule          = "cron(0 3 * * ? *)" # 03:00 UTC daily

    lifecycle {
      cold_storage_after = var.daily_cold_after_days
      delete_after       = var.daily_delete_after_days
    }

    dynamic "copy_action" {
      for_each = var.copy_to_region != null ? [1] : []
      content {
        destination_vault_arn = aws_backup_vault.dr[0].arn
        lifecycle {
          cold_storage_after = var.copy_cold_after_days
          delete_after       = var.copy_delete_after_days
        }
      }
    }
  }

  dynamic "rule" {
    for_each = var.enable_monthly_rule ? [1] : []
    content {
      rule_name         = "monthly-12m"
      target_vault_name = aws_backup_vault.this.name
      schedule          = "cron(0 4 1 * ? *)" # 04:00 UTC on the 1st of month
      lifecycle {
        cold_storage_after = var.monthly_cold_after_days
        delete_after       = var.monthly_delete_after_days
      }
    }
  }

  tags = var.tags
}

# Destination vault in DR region (only when copy is enabled)
resource "aws_backup_vault" "dr" {
  count       = var.copy_to_region != null ? 1 : 0
  provider    = aws.dr
  name        = "${var.name_prefix}-vault-dr"
  kms_key_arn = var.dr_kms_key_arn
  tags        = var.tags
}

# ------------------------------
# Selection (by tag and/or by ARNs)
# ------------------------------
resource "aws_backup_selection" "by_tag" {
  count        = var.selection_tag_key != null && var.selection_tag_value != null ? 1 : 0
  iam_role_arn = aws_iam_role.backup.arn
  name         = "tagged-resources"
  plan_id      = aws_backup_plan.this.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = var.selection_tag_key
    value = var.selection_tag_value
  }
}

resource "aws_backup_selection" "by_arns" {
  count        = length(var.resource_arns) > 0 ? 1 : 0
  iam_role_arn = aws_iam_role.backup.arn
  name         = "explicit-resources"
  plan_id      = aws_backup_plan.this.id
  resources    = var.resource_arns
}

# ------------------------------
# Vault Lock (WORM) — be careful; min/max delete_after enforced
# ------------------------------
resource "aws_backup_vault_lock_configuration" "lock" {
  count                      = var.enable_vault_lock ? 1 : 0
  backup_vault_name          = aws_backup_vault.this.name
  min_retention_days         = var.lock_min_retention_days
  max_retention_days         = var.lock_max_retention_days
  changeable_for_days        = var.lock_changeable_for_days
}

# ------------------------------
# Outputs
# ------------------------------
output "vault_name" { value = aws_backup_vault.this.name }
output "plan_id"    { value = aws_backup_plan.this.id }
output "backup_role_arn" { value = aws_iam_role.backup.arn }
output "dr_vault_name" { value = try(aws_backup_vault.dr[0].name, null) }
