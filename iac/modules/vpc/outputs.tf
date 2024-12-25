output "vpc_id" {
	value = aws_vpc.vpc.id
}

output "public_subnet_id" {
	value = aws_subnet.public_subnets.id
}

output "db_subnet_ids" {
	value = [for subnet in aws_subnet.db_subnets : subnet.id]
}