# ---------------------------
# VPC
# ---------------------------
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.environment}-${var.app_name}-vpc"
  }
}

# ---------------------------
# Subnets
# ---------------------------

# Public Subnets
resource "aws_subnet" "pub_1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.pub_sub_1a_cidr
  availability_zone       = var.availability_zone_a
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-${var.app_name}-pub-1a-sub"
  }
}

resource "aws_subnet" "pub_1c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.pub_sub_1c_cidr
  availability_zone       = var.availability_zone_c
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-${var.app_name}-pub-1c-sub"
  }
}

# Private Subnets for 1a
resource "aws_subnet" "pri1_1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.pri1_sub_1a_cidr
  availability_zone = var.availability_zone_a

  tags = {
    Name = "${var.environment}-${var.app_name}-pri1-1a-sub"
  }
}

resource "aws_subnet" "pri2_1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.pri2_sub_1a_cidr
  availability_zone = var.availability_zone_a
  
  tags = {
    Name = "${var.environment}-${var.app_name}-pri2-1a-sub"
  }
}

# Private Subnets for 1c
resource "aws_subnet" "pri1_1c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.pri1_sub_1c_cidr
  availability_zone = var.availability_zone_c
  
  tags = {
    Name = "${var.environment}-${var.app_name}-pri1-1c-sub"
  }
}

resource "aws_subnet" "pri2_1c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.pri2_sub_1c_cidr
  availability_zone = var.availability_zone_c
  
  tags = {
    Name = "${var.environment}-${var.app_name}-pri2-1c-sub"
  }
}

# ---------------------------
# Internet Gateway
# ---------------------------
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name = "${var.environment}-${var.app_name}-igw"
  }
}

# ---------------------------
# Route table
# ---------------------------
resource "aws_route_table" "pub" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  
  tags = {
    Name = "${var.environment}-${var.app_name}-pub-rt"
  }
}

# SubnetとRoute tableの関連付け
resource "aws_route_table_association" "pub_rt_associate_1a" {
  subnet_id      = aws_subnet.pub_1a.id
  route_table_id = aws_route_table.pub.id
}

resource "aws_route_table_association" "pub_rt_associate_1c" {
  subnet_id      = aws_subnet.pub_1c.id
  route_table_id = aws_route_table.pub.id
}

# Auroraのセキュリティグループ
resource "aws_security_group" "aurora" {
  name        = "${var.environment}-${var.app_name}-aurora-sg"
  description = "Security Group for both Aurora"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-${var.app_name}-aurora-sg"
  }
}
