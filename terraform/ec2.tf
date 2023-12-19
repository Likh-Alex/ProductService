resource "aws_instance" "product_service" {
  ami                    = "ami-024f768332f080c5e"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.ssh_key.key_name
  vpc_security_group_ids = [aws_security_group.product_service.id]


  tags = {
    Name = "product_service_instance"
  }

  user_data = <<-EOF
    #!/bin/bash
    apt update -y
    apt install -y docker.io
    systemctl start docker
    systemctl enable docker

    $(aws ecr get-login --no-include-email --region eu-central-1)

    docker run -d --name axonserver -p 8024:8024 -p 8124:8124 axoniq/axonserver:latest

    docker pull 154479180857.dkr.ecr.eu-central-1.amazonaws.com/product_service_repo:latest
    docker run -d --name my_product_service -p 8080:8080 154479180857.dkr.ecr.eu-central-1.amazonaws.com/product_service_repo:latest
  EOF
}

output "instance_ip" {
  description = "The public ip for ssh access"
  value       = aws_instance.product_service.public_ip
}
