variable "region" {
  description = "Primary AWS region"
  type        = string
  default     = "us-east-1"
}

variable "name_prefix" {
  description = "Prefix for resources"
  type        = string
  default     = "day27"
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {
    Project = "90DaysOfDevOps"
    Day     = "27"
  }
}

# Vault & KMS
variable "kms_key_arn" {
  description = "KMS key ARN for primary vault (optional)"
  type        = string
  default     = null
}

# SNS notifications
variable "enable_sns_notifications" {
  description = "Enable SNS notifications for backup/restore events"
  type        = bool
  default     = false
}

# Daily rule lifecycle
variable "daily_cold_after_days" {
  description = "Move to cold storage after N days (0 to skip)"
  type        = number
  default     = 7
}

variable "daily_delete_after_days" {
  description = "Delete recovery point after N days"
  type        = number
  default     = 35
}

# Monthly rule
variable "enable_monthly_rule" {
  description = "Enable a monthly rule with longer retention"
  type        = bool
  default     = true
}

variable "monthly_cold_after_days" {
  description = "Monthly: move to cold storage after N days"
  type        = number
  default     = 30
}

variable "monthly_delete_after_days" {
  description = "Monthly: delete after N days (e.g., ~360 days)"
  type        = number
  default     = 365
}

# Cross-region copy
variable "copy_to_region" {
  description = "Destination region for cross-region copy (null to disable)"
  type        = string
  default     = null
}

variable "dr_kms_key_arn" {
  description = "KMS key ARN in destination region (optional)"
  type        = string
  default     = null
}

variable "copy_cold_after_days" {
  description = "Copy: cold storage after N days"
  type        = number
  default     = 7
}

variable "copy_delete_after_days" {
  description = "Copy: delete after N days"
  type        = number
  default     = 90
}

# Selection
variable "selection_tag_key" {
  description = "Tag key to select resources (e.g., Backup)"
  type        = string
  default     = "Backup"
}

variable "selection_tag_value" {
  description = "Tag value to select resources (e.g., true)"
  type        = string
  default     = "true"
}

variable "resource_arns" {
  description = "Explicit resource ARNs to protect (overrides tag selection if provided)"
  type        = list(string)
  default     = []
}

# Vault Lock
variable "enable_vault_lock" {
  description = "Enable Backup Vault Lock (WORM). WARNING: Some settings become immutable."
  type        = bool
  default     = false
}

variable "lock_min_retention_days" {
  description = "Vault lock: minimum retention days"
  type        = number
  default     = 7
}

variable "lock_max_retention_days" {
  description = "Vault lock: maximum retention days"
  type        = number
  default     = 3650
}

variable "lock_changeable_for_days" {
  description = "Vault lock: days the policy can be changed (0 = immediate governance)"
  type        = number
  default     = 7
}
