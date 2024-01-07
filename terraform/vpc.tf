resource "aws_vpc" "product_service_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "product_service_internet_gateway" {
  vpc_id = aws_vpc.product_service_vpc.id

  tags = {
    Name = var.vpc_name
  }
}