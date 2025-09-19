variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name_prefix" {
  description = "Prefix for the S3 bucket name (a random suffix is appended)"
  type        = string
}

variable "force_destroy" {
  description = "Allow Terraform to delete non-empty buckets (use with caution)"
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Enable versioning on the bucket"
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "Server-side encryption algorithm: AES256 or aws:kms"
  type        = string
  default     = "AES256"
}

variable "kms_key_id" {
  description = "KMS key ID/ARN when using aws:kms"
  type        = string
  default     = null
}

# Lifecycle timings (days)
variable "transition_ia_days" {
  description = "Days before transitioning data/ objects to STANDARD_IA"
  type        = number
  default     = 30
}

variable "transition_glacier_days" {
  description = "Days before transitioning data/ objects to GLACIER"
  type        = number
  default     = 90
}

variable "expiration_days" {
  description = "Days before expiring current versions in data/"
  type        = number
  default     = 365
}

variable "noncurrent_transition_days" {
  description = "Days before transitioning noncurrent versions to GLACIER"
  type        = number
  default     = 30
}

variable "noncurrent_expiration_days" {
  description = "Days before expiring noncurrent versions"
  type        = number
  default     = 180
}

variable "abort_multipart_days" {
  description = "Abort incomplete multipart uploads after N days"
  type        = number
  default     = 7
}

# Logs rule
variable "logs_transition_days" {
  description = "Days before transitioning logs/ objects to GLACIER"
  type        = number
  default     = 60
}

variable "logs_expiration_days" {
  description = "Days before expiring logs/ objects"
  type        = number
  default     = 730
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {
    Project = "90DaysOfDevOps"
    Day     = "13"
  }
}
