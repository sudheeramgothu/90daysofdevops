output "config_bucket"        { value = aws_s3_bucket.config_logs.bucket }
output "recorder_name"       { value = aws_config_configuration_recorder.this.name }
output "rules"               {
  value = [
    aws_config_config_rule.s3_public_read.name,
    aws_config_config_rule.s3_public_write.name,
    aws_config_config_rule.ssh_disabled.name,
    aws_config_config_rule.ebs_encrypted.name,
    aws_config_config_rule.iam_password_policy.name,
    aws_config_config_rule.rds_encrypted.name
  ]
}
output "conformance_pack_name" { value = try(aws_config_conformance_pack.baseline[0].name, null) }
