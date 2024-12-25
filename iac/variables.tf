variable "region" {
  description = "AWS profile to use for deployment"
}

variable "region" {
  description = "AWS region to deploy"
}

variable "environment" {
  description = "Specify the environment"
}

variable "vpc_conf" {
  description = "VPC variables"  
}

variable "ec2_conf" {
  description = "EC2 configuration"
}

variable "rds_conf" {
  description = "RDS configuration"
}

variable "s3_conf" {
  description = "S3 configuration"
}