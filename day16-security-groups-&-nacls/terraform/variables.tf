variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "name_prefix" {
  description = "Name prefix for resources"
  type        = string
  default     = "day16"
}

variable "vpc_id" {
  description = "VPC ID (from Day 14)"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR (used for private NACL ingress)"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs (Day 14)"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs (Day 14)"
  type        = list(string)
}

variable "ssh_allowed_cidr" {
  description = "Public CIDR that may SSH to web hosts (e.g., X.X.X.X/32)"
  type        = string
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {
    Project = "90DaysOfDevOps"
    Day     = "16"
  }
}
