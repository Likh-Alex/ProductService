resource "aws_db_instance" "product_service_db" {
  engine                 = var.db_engine
  db_name                = var.db_name
  engine_version         = var.db_engine_version
  allocated_storage      = var.db_allocated_storage
  storage_type           = var.db_storage_type
  identifier             = var.db_identifier
  publicly_accessible    = var.db_publicly_accessible
  port                   = var.db_port
  skip_final_snapshot    = var.db_skip_final_snapshot
  instance_class         = var.db_instance_class
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]

  username = var.aws_rds_db_username
  password = var.aws_rds_db_password

  tags = {
    Name = var.db_name
  }
}
