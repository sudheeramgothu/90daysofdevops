variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "account_id" {
  description = "Your AWS account ID (used for IAM policy outputs)"
  type        = string
  default     = "111122223333"
}

variable "name_prefix" {
  description = "Prefix for KMS alias and resource names"
  type        = string
  default     = "day23"
}

variable "env" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "app_name" {
  description = "Application name (e.g., api, worker)"
  type        = string
  default     = "sampleapp"
}

variable "parameters" {
  description = "Map of plain String parameters"
  type        = map(string)
  default     = {
    LOG_LEVEL         = "info"
    FEATURE_X_ENABLED = "true"
  }
}

variable "secure_parameters" {
  description = "Map of SecureString parameters (KMS-encrypted)"
  type        = map(string)
  default     = {
    API_TOKEN = "replace-me"
  }
}

variable "create_kms_key" {
  description = "Create a new KMS key for SecureString/Secrets"
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "Use an existing KMS key ARN (set create_kms_key=false)"
  type        = string
  default     = null
}

variable "db_username" { type = string, default = "appuser" }
variable "db_password" { type = string, default = null, sensitive = true }
variable "db_name"     { type = string, default = "appdb" }
variable "db_host"     { type = string, default = "db.dev.local" }
variable "db_port"     { type = number, default = 5432 }
variable "secret_name" { type = string, default = "" }

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {
    Project = "90DaysOfDevOps"
    Day     = "23"
  }
}
