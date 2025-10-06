terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_sns_topic" "budget_alerts" {
  name = "${var.name_prefix}-budget-alerts"
  tags = var.tags
}

resource "aws_sns_topic_subscription" "email" {
  for_each = toset(var.emails)
  topic_arn = aws_sns_topic.budget_alerts.arn
  protocol  = "email"
  endpoint  = each.value
}

resource "aws_sns_topic_subscription" "https" {
  for_each = toset(var.https_endpoints)
  topic_arn = aws_sns_topic.budget_alerts.arn
  protocol  = "https"
  endpoint  = each.value
}

resource "aws_budgets_budget" "monthly_cost" {
  name              = "${var.name_prefix}-monthly-cost"
  budget_type       = "COST"
  limit_amount      = format("%.2f", var.budget_amount)
  limit_unit        = "USD"
  time_unit         = "MONTHLY"
  time_period_start = var.time_period_start

  dynamic "cost_types" {
    for_each = [1]
    content {
      include_credit             = true
      include_discount           = true
      include_other_subscription = true
      include_recurring          = true
      include_refund             = true
      include_subscription       = true
      include_support            = true
      include_tax                = true
      include_upfront            = true
      use_blended                = false
    }
  }

  dynamic "cost_filter" {
    for_each = length(var.services) > 0 ? [1] : []
    content {
      name   = "Service"
      values = var.services
    }
  }

  dynamic "cost_filter" {
    for_each = var.tag_key != null && length(var.tag_values) > 0 ? [1] : []
    content {
      name   = "TagKeyValue"
      values = [for v in var.tag_values : "${var.tag_key}$${v}"]
    }
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = var.threshold_forecast_percent
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_sns_topic_arns  = [aws_sns_topic.budget_alerts.arn]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = var.threshold_actual_percent
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_sns_topic_arns  = [aws_sns_topic.budget_alerts.arn]
  }

  tags = var.tags
}

output "budget_name" {
  value = aws_budgets_budget.monthly_cost.name
}

output "sns_topic_arn" {
  value = aws_sns_topic.budget_alerts.arn
}
