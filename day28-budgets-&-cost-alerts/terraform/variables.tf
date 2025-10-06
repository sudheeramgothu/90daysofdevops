variable "region" {
  description = "AWS region for API calls (Budgets is global, but provider still needs a region)"
  type        = string
  default     = "us-east-1"
}

variable "name_prefix" {
  description = "Prefix for budget and SNS topic names"
  type        = string
  default     = "day28"
}

variable "budget_amount" {
  description = "Monthly budget amount in USD"
  type        = number
  default     = 25
}

variable "threshold_forecast_percent" {
  description = "Percent of budget to alert on FORECASTED spend"
  type        = number
  default     = 80
}

variable "threshold_actual_percent" {
  description = "Percent of budget to alert on ACTUAL spend"
  type        = number
  default     = 100
}

variable "time_period_start" {
  description = "ISO 8601 start date for the budget (e.g., 2025-10-01T00:00:00Z)"
  type        = string
  default     = "2025-10-01T00:00:00Z"
}

variable "services" {
  description = "Optional list of AWS services to include (e.g., [\"AmazonEC2\"])"
  type        = list(string)
  default     = []
}

variable "tag_key" {
  description = "Optional tag key to filter by (used with tag_values)"
  type        = string
  default     = null
}

variable "tag_values" {
  description = "Values for the tag filter (paired with tag_key)"
  type        = list(string)
  default     = []
}

variable "emails" {
  description = "Email addresses to subscribe to the SNS topic"
  type        = list(string)
  default     = []
}

variable "https_endpoints" {
  description = "HTTPS endpoints to subscribe to the SNS topic (optional)"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {
    Project = "90DaysOfDevOps"
    Day     = "28"
  }
}
