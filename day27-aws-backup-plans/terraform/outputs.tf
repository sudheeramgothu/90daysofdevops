output "vault_name"          { value = aws_backup_vault.this.name }
output "plan_id"             { value = aws_backup_plan.this.id }
output "backup_role_arn"     { value = aws_iam_role.backup.arn }
output "dr_vault_name"       { value = try(aws_backup_vault.dr[0].name, null) }
