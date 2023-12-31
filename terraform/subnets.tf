# This data source retrieves the Availability Zones available to the AWS account.
data "aws_availability_zones" "available" {}

# This resource creates public subnets, one per Availability Zone.
resource "aws_subnet" "public" {
  count             = var.availability_zone_count
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, var.availability_zone_count + count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.main.id

  tags = {
    Name = "public-subnet-${count.index}"
  }
}

# This resource creates a route table with an egress route to the internet.
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = cidrsubnet(var.vpc_cidr_block, 8, var.availability_zone_count)
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# This resource associates the public subnets with the public route table.
resource "aws_route_table_association" "public" {
  count          = var.availability_zone_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# This resource associates the main route table with the VPC.
resource "aws_main_route_table_association" "main" {
  vpc_id         = aws_vpc.main.id
  route_table_id = aws_route_table.public.id
}

# This resource creates one Elastic IP per Availability Zone.
resource "aws_eip" "nat_gateway" {
  count  = var.availability_zone_count
  domain = "vpc"

  tags = {
    Name = "nat-gateway-eip-${count.index}"
  }
}

# This resource creates a NAT gateway in each public subnet (one per Availability Zone).
resource "aws_nat_gateway" "nat_gateway" {
  count         = var.availability_zone_count
  allocation_id = aws_eip.nat_gateway[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "nat-gateway-${count.index}"
  }
}

# This resource creates private subnets, one per Availability Zone.
resource "aws_subnet" "private" {
  count             = var.availability_zone_count
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, var.availability_zone_count)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.main.id

  tags = {
    Name = "private-subnet-${count.index}"
  }
}

# This resource creates private route tables, associated with each private subnet (one per Availability Zone).
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  count  = var.availability_zone_count

  route {
    cidr_block     = cidrsubnet(var.vpc_cidr_block, 8, var.availability_zone_count)
    nat_gateway_id = aws_nat_gateway.nat_gateway[count.index].id
  }

  tags = {
    Name = "private-route-table-${count.index}"
  }
}

# This resource associates the private subnets with the respective private route tables.
resource "aws_route_table_association" "private" {
  count          = var.availability_zone_count
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}