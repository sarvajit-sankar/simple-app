region = "ap-south-1"
environment = "test"
profile = ""

# VPC variables 
vpc_conf = {
  vpc = {
    cidr_vpc = "10.0.0.0/16"
    additional_tags = {
    }
  }
  public_subnets = {
    public_subnet_cidr_0 = "10.0.0.0/20"
    additional_tags = {
    }
  }
  private_app_subnets = {
    additional_tags = {
    }
  }

  private_db_subnets = {
    0 = {
      cidr_block = "10.0.16.0/20"
      additional_tags = {
      }
    }
    1 = {
      cidr_block = "10.0.32.0/20"
      additional_tags = {
      }
    }
  }

  # nat_gateway={
  #   additional_tags={}
  # }

  public_rt={
    additional_tags = {}
  }

  app_rt={
    additional_tags = {}
  }
  db_rt={
    additional_tags = {}
  }
}

# EC2 variables
ec2_conf = {
  instance = {
    instance_type = "t2.micro"
    key_name      = "your-key"
    associate_public_ip_address = true
    root_block_device = {
      delete_on_termination = true
      is_encrypted = true
    }        
    additional_tags = {}
  }
  security_group = {
    ingress_rules = [
      {
        port        = 22
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        port        = 8000
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }
}

# RDS variables
rds_conf = {
  instance = {
    instance_class    = "db.t3.micro"
    engine           = "mysql"
    engine_version   = "8.0"
    allocated_storage = 20
    storage_type         = "gp2"
    is_encrypted = true
    skip_final_snapshot  = true
    publicly_accessible  = false
    database_name    = "db-name"
    master_username  = "username"
    master_password  = "password"
    additional_tags  = {}
  }
}

# S3 variables
s3_conf = {
  bucket = {
    name = "bucket-name"
    additional_tags = {}
  }
}