output "instance_id" {
  value = aws_instance.web.id
}

output "public_ip" {
  value = try(aws_instance.web.public_ip, null)
}

output "private_ip" {
  value = aws_instance.web.private_ip
}
