variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "name_prefix" {
  description = "Prefix for resources"
  type        = string
  default     = "day19"
}

variable "vpc_id" {
  description = "VPC ID (for reference)"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for ASG"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security groups for instances (e.g., web/app SG)"
  type        = list(string)
}

variable "target_group_arn" {
  description = "ALB target group ARN (from Day 18)"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "desired_capacity" {
  description = "Desired instances"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Min ASG size"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Max ASG size"
  type        = number
  default     = 5
}

# Target Tracking
variable "requests_per_target" {
  description = "Target requests per target (ALB)"
  type        = number
  default     = 200
}

variable "alb_resource_label" {
  description = "Resource label for ALBRequestCountPerTarget metric (app/<lb-name>/<id>/targetgroup/<tg-name>/<id>)"
  type        = string
}

variable "enable_cpu_target_tracking" {
  description = "Also enable CPU utilization target tracking"
  type        = bool
  default     = false
}

variable "cpu_target" {
  description = "CPU target for ASGAverageCPUUtilization (%)"
  type        = number
  default     = 50
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {
    Project = "90DaysOfDevOps"
    Day     = "19"
  }
}
