variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "name_prefix" {
  description = "Prefix for created resources"
  type        = string
  default     = "day29"
}

variable "record_all_supported" {
  description = "Record all supported resource types"
  type        = bool
  default     = true
}

variable "include_global_resources" {
  description = "Include global resources (e.g., IAM)"
  type        = bool
  default     = true
}

variable "resource_types" {
  description = "Specific resource types to record (used if record_all_supported=false)"
  type        = list(string)
  default     = []
}

variable "snapshot_frequency" {
  description = "Delivery frequency for snapshots"
  type        = string
  default     = "TwentyFour_Hours"
}

variable "force_destroy" {
  description = "Allow destroy of the Config bucket with objects (use with care)"
  type        = bool
  default     = false
}

variable "enable_conformance_pack" {
  description = "Deploy a baseline conformance pack"
  type        = bool
  default     = false
}

variable "enable_s3_public_block_remediation" {
  description = "Enable remediation for S3 public read via SSM automation"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {
    Project = "90DaysOfDevOps"
    Day     = "29"
  }
}
