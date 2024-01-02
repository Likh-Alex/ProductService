resource "aws_security_group" "product_service" {
  name        = "product_service_sg"
  description = "Allow SSH and HTTP inbound traffic"

  # Allow SSH
  ingress {
    description = "Allow SSH inbound traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP traffic to the application port
  ingress {
    description = "Allow HTTP traffic to the application port"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Or restrict to specific IPs for better security
  }

  # Allow HTTPS traffic to the application port
  ingress {
    description = "Allow HTTPS traffic to the application port"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Or restrict to specific IPs for better security
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
