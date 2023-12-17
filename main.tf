terraform {
  backend "s3" {
    bucket = "product-service-terraform-state"
    key    = "terraform/state/terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "product_service" {
  ami           = "ami-0669b163befffbdfc"
  instance_type = "t2.micro"

  tags = {
    Name = "product_service_instance"
  }
}

#resource "aws_vpc" "main" {
#  cidr_block           = "10.0.0.0/16"
#  enable_dns_hostnames = true
#  enable_dns_support   = true
#
#  tags = {
#    Name = "main-vpc"
#  }
#}
#
#resource "aws_subnet" "private_subnet" {
#  vpc_id            = aws_vpc.main.id
#  cidr_block        = "10.0.2.0/24"
#  availability_zone = "eu-central-1"
#
#  tags = {
#    Name = "private-subnet"
#  }
#}
#
#resource "aws_internet_gateway" "gateway" {
#  vpc_id = aws_vpc.main.id
#
#  tags = {
#    Name = "main-internet-gateway"
#  }
#}
#
#resource "aws_route_table" "public_route_table" {
#  vpc_id = aws_vpc.main.id
#
#  route {
#    cidr_block = "0.0.0.0/0"
#    gateway_id = aws_internet_gateway.gateway.id
#  }
#}
#
#resource "aws_route_table_association" "public_table_association" {
#  subnet_id      = aws_subnet.private_subnet.id
#  route_table_id = aws_route_table.public_route_table.id
#}
#
#resource "aws_eip" "my_nat" {
#  domain = "vpc"
#}
#
#resource "aws_nat_gateway" "nat_gateway" {
#  allocation_id = aws_eip.my_nat.id
#  subnet_id     = aws_subnet.private_subnet.id
#
#  tags = {
#    Name = "main-nat-gateway"
#  }
#}
#
#resource "aws_route_table" "private_route_table" {
#  vpc_id = aws_vpc.main.id
#
#  route {
#    cidr_block     = "0.0.0.0/0"
#    nat_gateway_id = aws_nat_gateway.nat_gateway.id
#  }
#
#  tags = {
#    Name = "private-route-table"
#  }
#}
#
#resource "aws_route_table_association" "private_route_table_association" {
#  subnet_id      = aws_subnet.private_subnet.id
#  route_table_id = aws_route_table.private_route_table.id
#}
#
#resource "aws_iam_policy" "terraform_user_policy" {
#  name        = "TerraformUserPolicy"
#  description = "Policy for Terraform user to manage EC2 and VPC resources"
#
#  policy = jsonencode({
#    Version   = "2012-10-17",
#    Statement = [
#      {
#        Effect = "Allow",
#        Action = [
#          "ec2:RunInstances",
#          "ec2:CreateVpc",
#          "ec2:AllocateAddress",
#          "ec2:DescribeAddresses", // Add this line
#        ],
#        Resource = "*"
#      }
#    ]
#  })
#}
#
#resource "aws_iam_user_policy_attachment" "terraform_user_policy_attachment" {
#  user       = "terraform_test_user"
#  policy_arn = aws_iam_policy.terraform_user_policy.arn
#}

