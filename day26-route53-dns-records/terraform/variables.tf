variable "region" {
  description = "AWS region for API calls (Route53 is global, but provider still needs a region)"
  type        = string
  default     = "us-east-1"
}

variable "domain_name" {
  description = "Base domain (e.g., example.com)"
  type        = string
}

variable "create_zone" {
  description = "Create the hosted zone (true) or use an existing one (false)"
  type        = bool
  default     = false
}

variable "zone_id" {
  description = "Existing hosted zone ID (required if create_zone=false)"
  type        = string
  default     = null
}

# CloudFront mapping (Day 25)
variable "cloudfront_domain_name" {
  description = "Your CloudFront distribution domain name (e.g., d111111abcdef8.cloudfront.net)"
  type        = string
}

variable "cloudfront_zone_id" {
  description = "CloudFront hosted zone ID"
  type        = string
  default     = "Z2FDTNDATAQYW2"
}

variable "site_subdomain" {
  description = "Subdomain to point at CloudFront (e.g., www). Leave empty to skip."
  type        = string
  default     = "www"
}

variable "root_apex_alias" {
  description = "Also alias the root (apex) domain to CloudFront"
  type        = bool
  default     = false
}

# Optional ALB mapping (Day 18)
variable "create_alb_record" {
  description = "Create api.<domain> alias to an ALB"
  type        = bool
  default     = false
}

variable "alb_subdomain" {
  description = "Subdomain for the ALB target (default api)"
  type        = string
  default     = "api"
}

variable "alb_dns_name" {
  description = "ALB DNS name (from aws_lb.dns_name)"
  type        = string
  default     = null
}

variable "alb_zone_id" {
  description = "ALB hosted zone ID (from aws_lb.zone_id)"
  type        = string
  default     = null
}

# TXT records (verification)
variable "txt_records" {
  description = "Map of TXT records: name => value (use '@' for apex)"
  type        = map(string)
  default     = {}
}

variable "txt_ttl" {
  description = "TTL for TXT records"
  type        = number
  default     = 300
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {
    Project = "90DaysOfDevOps"
    Day     = "26"
  }
}
