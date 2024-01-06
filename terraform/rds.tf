resource "aws_db_instance" "product_service_db" {
  db_name                = "product_service_db"
  engine                 = "mysql"
  engine_version         = "8.0.35"
  allocated_storage      = 20
  storage_type           = "gp2"
  identifier             = "product-service-db"
  username               = var.db_username
  password               = var.db_password
  publicly_accessible    = true
  port                   = 3306
  skip_final_snapshot    = true
  instance_class         = "db.t2.micro"
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]

  tags = {
    Name = "product_service_db"
  }
}
