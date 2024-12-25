output "instance_id" {
  value = aws_instance.backend.id
}

output "public_ip" {
  value = aws_instance.backend.public_ip
}

output "backend_security_group_id" {
  value = aws_security_group.backend.id
}