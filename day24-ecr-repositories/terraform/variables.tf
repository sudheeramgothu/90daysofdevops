variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "env" {
  description = "Environment prefix for repos (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "repositories" {
  description = "List of repo base names (e.g., [\"api\",\"worker\"])"
  type        = list(string)
  default     = ["api"]
}

variable "scan_on_push" {
  description = "Enable image scanning on push"
  type        = bool
  default     = true
}

variable "image_tag_immutable" {
  description = "Make image tags immutable"
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "KMS key ARN for encryption (null uses AES256)"
  type        = string
  default     = null
}

variable "force_delete" {
  description = "Force delete repos with images on destroy (use with care)"
  type        = bool
  default     = false
}

# Lifecycle policy knobs
variable "untagged_keep_count" {
  description = "Keep N most recent untagged images"
  type        = number
  default     = 5
}

variable "tagged_keep_count" {
  description = "Keep M most recent tagged images that match tag_prefix_list"
  type        = number
  default     = 10
}

variable "tag_prefix_list" {
  description = "Tag prefixes to consider for the tagged rule (e.g., [\"v\", \"release-\"])"
  type        = list(string)
  default     = [""]
}

# Cross-account readers
variable "cross_account_reader_arns" {
  description = "List of AWS principal ARNs allowed read-only access (optional)"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {
    Project = "90DaysOfDevOps"
    Day     = "24"
  }
}
