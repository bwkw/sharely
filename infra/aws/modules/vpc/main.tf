# ---------------------------
# VPC
# ---------------------------
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.environment}-${var.app_name}-vpc"
  }
}

# ---------------------------
# Subnets
# ---------------------------

# Public Subnets
resource "aws_subnet" "pub_1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.pub_sub_1a_cidr
  availability_zone = var.availability_zone_a
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.environment}-${var.app_name}-pub-1a-sub"
  }
}

resource "aws_subnet" "pub_1c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.pub_sub_1c_cidr
  availability_zone = var.availability_zone_c
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

# ---------------------------
# Security Group
# ---------------------------
resource "aws_security_group" "ec2" {
  name        = "${var.environment}-${var.app_name}-ec2-sg"
  description = "For EC2"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "${var.environment}-${var.app_name}-ec2-sg"
  }

  # インバウンドルール
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allow_ip_list
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allow_ip_list
  }

  # アウトバウンドルール
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
