variable "region" {
  description = "AWS region to deploy"
}

variable "environment" {
  description = "Specify the environment"
}

variable "ec2_conf" {
    description = "EC2 conf to create ec2 resources"
}

variable "vpc_id" {
  description = "vpc id where resources would be deployed"
}

variable "subnet_id" {
  description = "subnet ID where resources would be deployed"
}