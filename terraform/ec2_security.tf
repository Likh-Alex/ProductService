resource "aws_security_group" "ec2_security_group" {
  name        = var.security_group_name
  description = "Allow SSH and HTTP inbound traffic"

  # Allow SSH
  ingress {
    description = "Allow SSH inbound traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow product service container traffic
  ingress {
    description = "Allow traffic to the product service container"
    from_port   = var.product_service_port
    to_port     = var.product_service_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow inbound MySQL connections
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

