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

# ---------------------
# SNS Topic + (optional) subscription
# ---------------------
resource "aws_sns_topic" "alerts" {
  name = "${var.name_prefix}-alerts"
  tags = var.tags
}

resource "aws_sns_topic_subscription" "email" {
  count     = var.alarm_email != null && var.alarm_email != "" ? 1 : 0
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alarm_email
}

locals {
  alarm_actions = concat([aws_sns_topic.alerts.arn], var.alarm_actions_extra)
  ok_actions    = var.ok_actions_enable ? [aws_sns_topic.alerts.arn] : []
}

# ---------------------
# ALB metrics (AWS/ApplicationELB)
# Dimensions use ARN suffixes.
# ---------------------

# 1) ALB 5xx (ELB-generated) — spikes indicate LB/SSL/errors before target
resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  alarm_name          = "${var.name_prefix}-alb-5xx"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  statistic           = "Sum"
  threshold           = var.alb_5xx_threshold
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = var.lb_arn_suffix
  }

  alarm_description = "ALB ELB-generated 5xx above ${var.alb_5xx_threshold} in 5m"
  alarm_actions     = local.alarm_actions
  ok_actions        = local.ok_actions
  tags              = var.tags
}

# 2) ALB Target Response Time (average latency)
resource "aws_cloudwatch_metric_alarm" "alb_latency" {
  alarm_name          = "${var.name_prefix}-alb-latency"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = var.alb_latency_threshold
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = var.lb_arn_suffix
  }

  alarm_description = "ALB average target response time > ${var.alb_latency_threshold}s"
  alarm_actions     = local.alarm_actions
  ok_actions        = local.ok_actions
  tags              = var.tags
}

# ---------------------
# Target Group metrics (AWS/ApplicationELB)
# ---------------------

# 3) Unhealthy hosts in Target Group
resource "aws_cloudwatch_metric_alarm" "tg_unhealthy" {
  alarm_name          = "${var.name_prefix}-tg-unhealthy"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = var.tg_unhealthy_threshold
  treat_missing_data  = "notBreaching"

  dimensions = {
    TargetGroup = var.tg_arn_suffix
    LoadBalancer = var.lb_arn_suffix
  }

  alarm_description = "Target Group unhealthy hosts > ${var.tg_unhealthy_threshold}"
  alarm_actions     = local.alarm_actions
  ok_actions        = local.ok_actions
  tags              = var.tags
}

# 4) Healthy host minimum (breach when below)
resource "aws_cloudwatch_metric_alarm" "tg_healthy_min" {
  alarm_name          = "${var.name_prefix}-tg-healthy-min"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = var.tg_min_healthy_hosts
  treat_missing_data  = "breaching"

  dimensions = {
    TargetGroup = var.tg_arn_suffix
    LoadBalancer = var.lb_arn_suffix
  }

  alarm_description = "Healthy hosts < ${var.tg_min_healthy_hosts}"
  alarm_actions     = local.alarm_actions
  ok_actions        = local.ok_actions
  tags              = var.tags
}

# ---------------------
# ASG metrics (AWS/AutoScaling)
# ---------------------

# 5) InService instances below threshold (capacity protection)
resource "aws_cloudwatch_metric_alarm" "asg_inservice_low" {
  alarm_name          = "${var.name_prefix}-asg-inservice-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "GroupInServiceInstances"
  namespace           = "AWS/AutoScaling"
  period              = 60
  statistic           = "Average"
  threshold           = var.asg_min_inservice
  treat_missing_data  = "breaching"

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  alarm_description = "ASG InService instances < ${var.asg_min_inservice}"
  alarm_actions     = local.alarm_actions
  ok_actions        = local.ok_actions
  tags              = var.tags
}

# 6) Excessive terminating instances (optional visibility)
resource "aws_cloudwatch_metric_alarm" "asg_terminating_spike" {
  count               = var.enable_asg_terminating_alarm ? 1 : 0
  alarm_name          = "${var.name_prefix}-asg-terminating-spike"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "GroupTerminatingInstances"
  namespace           = "AWS/AutoScaling"
  period              = 60
  statistic           = "Sum"
  threshold           = var.asg_terminating_threshold
  treat_missing_data  = "notBreaching"

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  alarm_description = "ASG terminating instances spike > ${var.asg_terminating_threshold} in 1m"
  alarm_actions     = local.alarm_actions
  ok_actions        = local.ok_actions
  tags              = var.tags
}

# ---------------------
# Outputs
# ---------------------
output "sns_topic_arn" {
  value = aws_sns_topic.alerts.arn
}

output "alarm_names" {
  value = [
    aws_cloudwatch_metric_alarm.alb_5xx.alarm_name,
    aws_cloudwatch_metric_alarm.alb_latency.alarm_name,
    aws_cloudwatch_metric_alarm.tg_unhealthy.alarm_name,
    aws_cloudwatch_metric_alarm.tg_healthy_min.alarm_name,
    aws_cloudwatch_metric_alarm.asg_inservice_low.alarm_name
  ]
}
