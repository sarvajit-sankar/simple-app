data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "backend" {
    ami           = data.aws_ami.amazon_linux_2.id
    instance_type = var.ec2_conf.instance.instance_type
    subnet_id     = var.subnet_id
    key_name      = var.ec2_conf.instance.key_name
    associate_public_ip_address = var.ec2_conf.instance.associate_public_ip_address
    vpc_security_group_ids = [aws_security_group.backend.id]

    user_data = <<-EOF
                #!/bin/bash
                yum update -y
                yum install -y python3.11 python3.11-pip git screen
                echo 'alias python=python3.11' >> /home/ec2-user/.bashrc
                echo 'alias pip=pip3.11' >> /home/ec2-user/.bashrc
                EOF

    root_block_device {
        delete_on_termination = var.ec2_conf.instance.root_block_device.delete_on_termination
        encrypted = var.ec2_conf.instance.root_block_device.is_encrypted
    }

    tags = merge(
    {
        Name        = "${var.environment}-backend"
        Environment = var.environment
    },
    var.ec2_conf.instance.additional_tags
    )
}

resource "aws_security_group" "backend" {
  name = "${var.environment}-backend-sg"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ec2_conf.security_group.ingress_rules
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-backend-sg"
    Environment = var.environment
  }
}