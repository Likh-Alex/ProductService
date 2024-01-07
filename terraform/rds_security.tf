resource "aws_security_group" "rds_sg" {
  name   = var.rds_sg_name
  vpc_id = aws_vpc.product_service_vpc.id

  # Allow inbound MySQL connections
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.rds_sg_name
  }
}