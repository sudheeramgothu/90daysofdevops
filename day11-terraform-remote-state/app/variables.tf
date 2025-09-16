variable "region" {
  description = "AWS region for the app"
  type        = string
  default     = "us-east-1"
}

variable "name_prefix" {
  description = "Prefix to ensure unique names"
  type        = string
  default     = "devopsday11"
}

variable "app_name" {
  description = "Application name stored in SSM Parameter"
  type        = string
  default     = "day11-remote-state-demo"
}