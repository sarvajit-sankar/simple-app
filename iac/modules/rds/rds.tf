resource "aws_db_subnet_group" "main" {
  name        = "${var.environment}-db-subnet-group"
  subnet_ids  = [var.subnet_id]
  description = "DB subnet group for ${var.environment}"

  tags = {
    Name        = "${var.environment}-db-subnet-group"
    Environment = var.environment
  }
}

resource "aws_db_instance" "main" {
  identifier        = "${var.environment}-db"
  instance_class    = var.rds_conf.instance.instance_class
  engine            = var.rds_conf.instance.engine
  engine_version    = var.rds_conf.instance.engine_version
  db_name           = var.rds_conf.instance.database_name
  username          = var.rds_conf.instance.master_username
  password          = var.rds_conf.instance.master_password
  allocated_storage     = var.rds_conf.instance.allocated_storage
  storage_encrypted   = var.rds_conf.instance.is_encrypted
  storage_type         = var.rds_conf.instance.storage_type
  skip_final_snapshot  = var.rds_conf.instance.skip_final_snapshot
  publicly_accessible  = var.rds_conf.instance.publicly_accessible
  
  vpc_security_group_ids = [aws_security_group.db.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name

  tags = merge(
    {
      Name        = "${var.environment}-db"
      Environment = var.environment
    },
    var.rds_conf.instance.additional_tags
  )
}

resource "aws_security_group" "db" {
  name_prefix = "${var.environment}-db-"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.whitelist_sg_id]
  }

  tags = {
    Name        = "${var.environment}-db-sg"
    Environment = var.environment
  }
}