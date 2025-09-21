output "s3_gateway_endpoint_id" {
  value = aws_vpc_endpoint.s3_gw.id
}

output "dynamodb_gateway_endpoint_id" {
  value = aws_vpc_endpoint.dynamodb_gw.id
}

output "interface_endpoint_ids" {
  value = [for k, v in aws_vpc_endpoint.interface : v.id]
}

output "vpce_security_group_id" {
  value = aws_security_group.vpce.id
}
