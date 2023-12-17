resource "aws_instance" "product_service" {
  ami           = "ami-0669b163befffbdfc"
  instance_type = "t2.micro"

  tags = {
    Name = "product_service_instance"
  }
}