# Terraform code for creating a vpc with 2 public, private and database subnets

# VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = merge({
    Name = var.vpc_name
  }, var.tags)
}

# Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = merge({
    Name = "${var.vpc_name}-igw"
  }, var.tags)
}

# Create a NAT gateway EIP
resource "aws_eip" "nat_eip" {
  tags = merge({
    Name = "${var.vpc_name}-nat-eip"
  }, var.tags)
}

# NAT gateway in any public subnet (here we choose the first one)
resource "aws_nat_gateway" "nat_gw" {
  depends_on    = [aws_internet_gateway.igw]
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = values(aws_subnet.public)[0].id
  tags = merge({
    Name = "${var.vpc_name}-nat-gw"
  }, var.tags)
}

# Public subnets
resource "aws_subnet" "public" {
  for_each = {
    for key, value in var.public_subnets :
    key => value
  }

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true
  tags = merge({
    Name = each.value.name
  }, var.tags)
}

# Private subnets
resource "aws_subnet" "private" {
  for_each = {
    for key, value in var.private_subnets :
    key => value
  }

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.availability_zone
  tags = merge({
    Name = each.value.name
  }, var.tags)
}

# Database subnets
resource "aws_subnet" "database" {

  for_each = {
    for key, value in var.database_subnets :
    key => value
  }

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.availability_zone
  tags = merge({
    Name = each.value.name
  }, var.tags)
}

# Route table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge({
    Name = "${var.vpc_name}-public-rt"
  }, var.tags)
}

# Route table association for public subnets
resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# Route table for private and database subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  # Add any routes for the private and database subnets here
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = merge({
    Name = "${var.vpc_name}-private-rt"
  }, var.tags)
}

# Route table association for private and database subnets
resource "aws_route_table_association" "private" {
  for_each       = merge(aws_subnet.private, aws_subnet.database)
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}