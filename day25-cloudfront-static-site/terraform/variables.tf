variable "region" {
  description = "Region for S3/APIs (CloudFront is global, ACM cert must be in us-east-1)"
  type        = string
  default     = "us-east-1"
}

variable "name_prefix" {
  description = "Prefix for named resources"
  type        = string
  default     = "day25"
}

variable "bucket_name" {
  description = "Unique S3 bucket name for the static site"
  type        = string
}

variable "default_root_object" {
  description = "Default root object for CloudFront"
  type        = string
  default     = "index.html"
}

variable "force_destroy" {
  description = "Allow destroy of buckets with objects (use with care)"
  type        = bool
  default     = false
}

variable "enable_logging" {
  description = "Enable CloudFront access logging to a separate S3 bucket"
  type        = bool
  default     = false
}

# Custom domain / TLS
variable "domain_name" {
  description = "Primary CNAME for the distribution (optional)"
  type        = string
  default     = null
}

variable "alternate_domains" {
  description = "Additional CNAMEs"
  type        = list(string)
  default     = []
}

variable "certificate_arn" {
  description = "ACM certificate ARN in us-east-1 (required if using a custom domain)"
  type        = string
  default     = null
}

variable "price_class" {
  description = "CloudFront price class"
  type        = string
  default     = "PriceClass_100"
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {
    Project = "90DaysOfDevOps"
    Day     = "25"
  }
}
