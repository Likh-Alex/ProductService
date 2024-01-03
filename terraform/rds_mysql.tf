resource "aws_db_instance" "product_service_db" {
  engine              = "mysql"
  engine_version      = "8.0.35"
  allocated_storage   = 20
  storage_type        = "gp2"
  identifier          = "product-service-db"
  username            = "admin"
  password            = "sashk4!admin?"
  publicly_accessible = true
  skip_final_snapshot = true
  instance_class      = "db.t2.micro"

  tags = {
    Name = "product-service-db"
  }
}
