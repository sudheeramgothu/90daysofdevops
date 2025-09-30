output "primary_endpoint_address" {
  value = aws_elasticache_replication_group.this.primary_endpoint_address
}

output "reader_endpoint_address" {
  value = aws_elasticache_replication_group.this.reader_endpoint_address
}

output "redis_sg_id" {
  value = aws_security_group.redis.id
}

output "subnet_group_name" {
  value = aws_elasticache_subnet_group.this.name
}

output "auth_token_note" {
  value = var.auth_token != null && var.auth_token != "" ? "Using provided auth_token" : "Auth token generated (refer to your state/variables management)"
}
