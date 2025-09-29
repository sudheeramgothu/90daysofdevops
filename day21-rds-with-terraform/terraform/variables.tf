variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "name_prefix" {
  description = "Prefix for all resources"
  type        = string
  default     = "day21"
}

variable "vpc_id" {
  description = "VPC ID (from Day 14)"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for the DB subnet group"
  type        = list(string)
}

variable "app_security_group_ids" {
  description = "App SG IDs allowed to connect to PostgreSQL (ingress 5432)"
  type        = list(string)
  default     = []
}

variable "extra_cidr_ingress" {
  description = "Optional CIDRs allowed to access PostgreSQL (e.g., bastion)"
  type        = list(string)
  default     = []
}

# Engine / Version
variable "engine" {
  description = "RDS engine"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "RDS engine version"
  type        = string
  default     = "16.4"
}

variable "parameter_group_family" {
  description = "Parameter group family (e.g., postgres16)"
  type        = string
  default     = "postgres16"
}

# Instance sizing
variable "instance_class" {
  description = "DB instance class (e.g., db.t3.micro)"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Initial storage (GiB)"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Autoscaling storage upper bound (GiB)"
  type        = number
  default     = 100
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = true
}

# Backups & maintenance
variable "backup_retention_days" {
  description = "Days to retain automated backups"
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "Preferred backup window (UTC)"
  type        = string
  default     = "03:00-04:00"
}

variable "maintenance_window" {
  description = "Preferred maintenance window (UTC)"
  type        = string
  default     = "sun:04:00-sun:05:00"
}

variable "apply_immediately" {
  description = "Apply modifications immediately (may cause disruption)"
  type        = bool
  default     = false
}

# Deletion protection & snapshots
variable "deletion_protection" {
  description = "Protect the DB from deletion"
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot on destroy"
  type        = bool
  default     = false
}

# Encryption
variable "kms_key_id" {
  description = "KMS key for storage/perf insights (null uses default RDS key)"
  type        = string
  default     = null
}

# Credentials
variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Master/initial username"
  type        = string
  default     = "appuser"
}

variable "db_password" {
  description = "Optional explicit password (otherwise generated)"
  type        = string
  default     = null
  sensitive   = true
}

variable "enable_secrets_manager" {
  description = "Store credentials in Secrets Manager"
  type        = bool
  default     = true
}

variable "enable_performance_insights" {
  description = "Enable Performance Insights"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {
    Project = "90DaysOfDevOps"
    Day     = "21"
  }
}
