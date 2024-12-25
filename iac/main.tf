terraform {
  required_version = ">= 0.15.0"
#  backend "s3" {
# Pre-existing bucket name in which to store the terraform state file
#   bucket = "<remote-state-bucket>"
# Key path within bucket where state will be stored. This path will be prefixed with Environment tag in code
#   key    = "<terraform.tfstate>"
# Region where dynamodb table and s3 bucket is created. Both needs to be in same region
#   region = "<us-east-1>"
# To enable encryption for the remote state stored in S3
#   encrypt = true
# Name of dynamodb table to be used for Remote state locking which has LockID of type "String" as Primary Key 
#   dynamodb_table = "<remote-state-table>"
# if using workspace, you can use a prefix to store remote state of workspace separately. This prefix will act as key to your workspace.
  # workspace_key_prefix = "<development>"
# }
}

provider "aws" {
  region = var.region
  profile = var.profile
}

# Module for VPC and related resources
module "vpc"{
  source = "./modules/vpc" 
  region=var.region
  environment = var.environment
  vpc_conf= var.vpc_conf
}

module "ec2" {
  source      = "./modules/ec2"
  region      = var.region
  environment = var.environment
  ec2_conf    = var.ec2_conf
  vpc_id      = module.vpc.vpc_id
  subnet_id   = module.vpc.public_subnet_id
}

module "rds" {
  source      = "./modules/rds"
  region      = var.region
  environment = var.environment
  rds_conf    = var.rds_conf
  vpc_id      = module.vpc.vpc_id
  subnet_id   = module.vpc.db_subnet_id
  whitelist_sg_id = module.ec2.backend_security_group_id
}

module "s3" {
  source      = "./modules/s3"
  region      = var.region
  environment = var.environment
  s3_conf     = var.s3_conf
}