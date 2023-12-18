resource "aws_instance" "product_service" {
  ami           = "ami-0669b163befffbdfc"
  instance_type = "t2.micro"

  tags = {
    Name = "product_service_instance"
  }

  user_data = <<-EOF
    #!/bin/bash
    apt update
    apt install docker
    docker run -d \
    --name axonserver \
    -p 8024:8024 \
    -p 8124:8124 \
    axoniq/axonserver:latest
    docker pull 154479180857.dkr.ecr.eu-central-1.amazonaws.com/product_service_repo:latest
    docker run -d \
  EOF
}