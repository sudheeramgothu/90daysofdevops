output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = [for s in aws_subnet.public : s.id]
}

output "private_subnet_ids" {
  value = [for s in aws_subnet.private : s.id]
}

output "nat_gateway_ids" {
  value = [for n in aws_nat_gateway.this : n.id]
}

output "public_route_table_id" {
  value = aws_route_table.public.id
}
