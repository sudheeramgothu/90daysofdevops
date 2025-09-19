variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "name_prefix" {
  description = "Name prefix for all resources"
  type        = string
  default     = "day14"
}

variable "vpc_cidr" {
  description = "Main VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "az_count" {
  description = "How many AZs to use (<= number of available AZs in region)"
  type        = number
  default     = 2
}

variable "public_subnet_newbits" {
  description = "Newbits for public subnets (cidrsubnet); higher => smaller subnets"
  type        = number
  default     = 8
}

variable "private_subnet_newbits" {
  description = "Newbits for private subnets (cidrsubnet); higher => smaller subnets"
  type        = number
  default     = 8
}

variable "single_nat" {
  description = "Use a single NAT gateway (cost saver) vs one per AZ (HA)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {
    Project = "90DaysOfDevOps"
    Day     = "14"
  }
}
