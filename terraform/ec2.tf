resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
      },
    ],
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  role = aws_iam_role.ec2_role.name
}

resource "aws_instance" "product_service" {
  ami                    = "ami-024f768332f080c5e"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.ssh_key.key_name
  vpc_security_group_ids = [aws_security_group.product_service.id]

  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.id

  tags = {
    Name = "product_service_instance"
  }

  user_data = <<-EOF
  #!/bin/bash
  yum update -y
  yum install -y docker unzip

  # Start and enable Docker
  systemctl start docker
  systemctl enable docker

  # Install AWS CLI v2 (If needed. Amazon Linux 2 comes with AWS CLI v1 pre-installed)
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install

  # Pull and run the Axon server
  docker run -d --name axonserver -p 8024:8024 -p 8124:8124 axoniq/axonserver:latest

  # Authenticate with ECR and Pull the Docker image
  aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 154479180857.dkr.ecr.eu-central-1.amazonaws.com
  docker pull 154479180857.dkr.ecr.eu-central-1.amazonaws.com/product_service_repo:latest
  docker run -d --name my_product_service -p 8080:8080 154479180857.dkr.ecr.eu-central-1.amazonaws.com/product_service_repo:latest
EOF

}

output "instance_ip" {
  description = "The public ip for ssh access"
  value       = aws_instance.product_service.public_ip
}
