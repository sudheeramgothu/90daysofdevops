variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "name_prefix" {
  description = "Resource name prefix"
  type        = string
  default     = "day18"
}

variable "vpc_id" {
  description = "VPC ID for the ALB & Target Group"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of PUBLIC subnet IDs for the ALB"
  type        = list(string)
}

variable "certificate_arn" {
  description = "ACM certificate ARN used by the HTTPS listener"
  type        = string
}

variable "instance_ids" {
  description = "Instance IDs to register in the target group (e.g., Day 17 instance)"
  type        = list(string)
  default     = []
}

variable "target_port" {
  description = "Target port (e.g., 80 for NGINX)"
  type        = number
  default     = 80
}

variable "health_check_path" {
  description = "ALB target group health check path"
  type        = string
  default     = "/"
}

variable "enable_http_redirect" {
  description = "Create HTTP (80) listener that redirects to HTTPS (443)"
  type        = bool
  default     = true
}

variable "ssl_policy" {
  description = "SSL policy for the HTTPS listener"
  type        = string
  default     = "ELBSecurityPolicy-2016-08"
}

variable "enable_access_logs" {
  description = "Enable ALB access logs to an S3 bucket"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {
    Project = "90DaysOfDevOps"
    Day     = "18"
  }
}
