output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "ec2_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = module.ec2.public_ip
}

output "rds_endpoint" {
  description = "The RDS instance endpoint"
  value       = module.rds.endpoint
}

output "s3_website_endpoint" {
  description = "The S3 static website endpoint"
  value       = module.s3.website_endpoint
}