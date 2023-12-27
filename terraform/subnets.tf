data "aws_availability_zones" "available" {}

# One public subnet per availability zone
resource "aws_subnet" "public" {
  count             = var.availability_zone_count
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, var.availability_zone_count + count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.main.id

  tags = {
    Name = "public-subnet-${count.index}"
  }
}

# Route table with egress to internet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Associate public subnet with public route table
resource "aws_route_table_association" "public" {
  count          = var.availability_zone_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Associate main route table with VPC
resource "aws_main_route_table_association" "main" {
  vpc_id         = aws_vpc.main.id
  route_table_id = aws_route_table.public.id
}

# Creates one EIP per availability zone
resource "aws_eip" "nat_gateway" {
  count = var.availability_zone_count
  vpc   = true

  tags = {
    Name = "nat-gateway-eip-${count.index}"
  }
}

# Creates a NAT gateway in each public subnet per availability zone
resource "aws_nat_gateway" "nat_gateway" {
  count         = var.availability_zone_count
  allocation_id = aws_eip.nat_gateway[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "nat-gateway-${count.index}"
  }
}

# One private subnet per availability zone
resource "aws_subnet" "private" {
  count             = var.availability_zone_count
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, var.availability_zone_count + count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.main.id

  tags = {
    Name = "private-subnet-${count.index}"
  }
}

# Associate private subnet with private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  count  = var.availability_zone_count

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway[count.index].id
  }

  tags = {
    Name = "private-route-table-${count.index}"
  }
}

# Associate private subnet with private route table
resource "aws_route_table_association" "private" {
  count          = var.availability_zone_count
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}