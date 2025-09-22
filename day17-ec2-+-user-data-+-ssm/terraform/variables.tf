variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "name_prefix" {
  description = "Name prefix for instance and IAM resources"
  type        = string
  default     = "day17"
}

variable "vpc_id" {
  description = "VPC ID (from Day 14) - for reference"
  type        = string
}

variable "subnet_id" {
  description = "Subnet to launch the instance in (public or private)"
  type        = string
}

variable "security_group_ids" {
  description = "List of SGs to attach (e.g., Day 16 web_sg)"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "associate_public_ip" {
  description = "Associate a public IP (true for public subnet; false for private)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {
    Project = "90DaysOfDevOps"
    Day     = "17"
  }
}
