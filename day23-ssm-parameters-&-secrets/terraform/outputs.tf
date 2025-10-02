output "param_prefix" { value = local.prefix }
output "secret_name"  { value = aws_secretsmanager_secret.db.name }
output "kms_key_arn"  { value = local.kms_arn }
output "app_access_policy_json" {
  value       = data.aws_iam_policy_document.app_ssm_secrets_access.json
  description = "Attach this as inline policy to your app's instance/task role"
}
