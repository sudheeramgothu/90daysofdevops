output "db_endpoint" {
  value = aws_db_instance.postgres.address
}

output "db_port" {
  value = aws_db_instance.postgres.port
}

output "db_identifier" {
  value = aws_db_instance.postgres.id
}

output "db_parameter_group" {
  value = aws_db_parameter_group.pg.name
}

output "db_subnet_group" {
  value = aws_db_subnet_group.db.name
}

output "db_security_group_id" {
  value = aws_security_group.db.id
}

output "secret_arn" {
  value       = try(aws_secretsmanager_secret.db_credentials[0].arn, null)
  description = "Secrets Manager secret with DB credentials (if enabled)"
}
