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
