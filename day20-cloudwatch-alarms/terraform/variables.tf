variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "name_prefix" {
  description = "Alarm/SNS name prefix"
  type        = string
  default     = "day20"
}

# From Day 18
variable "lb_arn_suffix" {
  description = "ALB ARN suffix (app/<lb-name>/<id>)"
  type        = string
}

variable "tg_arn_suffix" {
  description = "Target Group ARN suffix (targetgroup/<tg-name>/<id>)"
  type        = string
}

# From Day 19
variable "asg_name" {
  description = "Auto Scaling Group name"
  type        = string
}

# Thresholds
variable "alb_5xx_threshold" {
  description = "ALB ELB 5xx sum over 5 minutes"
  type        = number
  default     = 5
}

variable "alb_latency_threshold" {
  description = "ALB average target response time (seconds)"
  type        = number
  default     = 1.5
}

variable "tg_unhealthy_threshold" {
  description = "Unhealthy hosts threshold"
  type        = number
  default     = 0
}

variable "tg_min_healthy_hosts" {
  description = "Minimum healthy hosts required"
  type        = number
  default     = 1
}

variable "asg_min_inservice" {
  description = "Minimum ASG InService instances required"
  type        = number
  default     = 1
}

variable "enable_asg_terminating_alarm" {
  description = "Enable ASG terminating instances spike alarm"
  type        = bool
  default     = false
}

variable "asg_terminating_threshold" {
  description = "Terminating instances spike threshold (sum over 1m)"
  type        = number
  default     = 2
}

# Notifications
variable "alarm_email" {
  description = "Optional email to subscribe to SNS"
  type        = string
  default     = null
}

variable "alarm_actions_extra" {
  description = "Additional ARNs to notify (e.g., Ops tools, Lambda)"
  type        = list(string)
  default     = []
}

variable "ok_actions_enable" {
  description = "Send OK notifications"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {
    Project = "90DaysOfDevOps"
    Day     = "20"
  }
}
