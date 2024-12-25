variable "region" {
  description = "AWS region to deploy"
}

variable "environment" {
  description = "Specify the environment"
}

variable "rds_conf" {
    description = "rds conf to create rds resources"
}

variable "vpc_id" {
  description = "vpc id where resources would be deployed"
}

variable "subnet_id" {
  description = "subnet ID where resources would be deployed"
}

variable "whitelist_sg_id" {
    description = "Security group to be whitelisted on DB"
}