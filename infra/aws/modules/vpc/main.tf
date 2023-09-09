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

# プライベートサブネットのルートテーブル
resource "aws_route_table" "pri" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name = "${var.environment}-${var.app_name}-pri-rt"
  }
}

# プライベートサブネットとルートテーブルの関連付け
resource "aws_route_table_association" "pri1_rt_associate_1a" {
  subnet_id      = aws_subnet.pri1_1a.id
  route_table_id = aws_route_table.pri.id
}

resource "aws_route_table_association" "pri1_rt_associate_1c" {
  subnet_id      = aws_subnet.pri1_1c.id
  route_table_id = aws_route_table.pri.id
}

resource "aws_route_table_association" "pri2_rt_associate_1a" {
  subnet_id      = aws_subnet.pri2_1a.id
  route_table_id = aws_route_table.pri.id
}

resource "aws_route_table_association" "pri2_rt_associate_1c" {
  subnet_id      = aws_subnet.pri2_1c.id
  route_table_id = aws_route_table.pri.id
}

# パブリックALBのセキュリティグループ
resource "aws_security_group" "pub_alb" {
  name        = "${var.environment}-${var.app_name}-pub-alb-sg"
  description = "Security Group for Public ALB"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-${var.app_name}-pub-alb-sg"
  }
}

resource "aws_security_group_rule" "pub_alb_ingress_http" {
  security_group_id = aws_security_group.pub_alb.id

  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "pub_alb_ingress_https" {
  security_group_id = aws_security_group.pub_alb.id

  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "pub_alb_egress_http" {
  security_group_id = aws_security_group.pub_alb.id

  type        = "egress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  source_security_group_id = aws_security_group.next_js_ecs_tasks.id
}

resource "aws_security_group_rule" "pub_alb_egress_https" {
  security_group_id = aws_security_group.pub_alb.id

  type        = "egress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  source_security_group_id = aws_security_group.next_js_ecs_tasks.id
}

# Next.jsコンテナのセキュリティグループ
resource "aws_security_group" "next_js_ecs_tasks" {
  name        = "${var.environment}-${var.app_name}-next-js-ecs-tasks-sg"
  description = "Security Group for Next.js ECS Tasks"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-${var.app_name}-next-js-ecs-tasks-sg"
  }
}

resource "aws_security_group_rule" "next_js_ecs_ingress_http" {
  security_group_id = aws_security_group.next_js_ecs_tasks.id

  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.pub_alb.id
}

resource "aws_security_group_rule" "next_js_ecs_ingress_https" {
  security_group_id = aws_security_group.next_js_ecs_tasks.id

  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.pub_alb.id
}

resource "aws_security_group_rule" "next_js_ecs_egress_http" {
  security_group_id = aws_security_group.next_js_ecs_tasks.id

  type        = "egress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  source_security_group_id = aws_security_group.pri_alb.id
}

resource "aws_security_group_rule" "next_js_ecs_egress_https" {
  security_group_id = aws_security_group.next_js_ecs_tasks.id

  type        = "egress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  source_security_group_id = aws_security_group.pri_alb.id
}

# プライベートALBのセキュリティグループ
resource "aws_security_group" "pri_alb" {
  name        = "${var.environment}-${var.app_name}-pri-alb-sg"
  description = "Security Group for Private ALB"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-${var.app_name}-pri-alb-sg"
  }
}

resource "aws_security_group_rule" "pri_alb_ingress_http" {
  security_group_id = aws_security_group.pri_alb.id

  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.next_js_ecs_tasks.id
}

resource "aws_security_group_rule" "pri_alb_ingress_https" {
  security_group_id = aws_security_group.pri_alb.id

  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.next_js_ecs_tasks.id
}

resource "aws_security_group_rule" "pri_alb_egress_http" {
  security_group_id = aws_security_group.pri_alb.id

  type        = "egress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  source_security_group_id = aws_security_group.go_ecs_tasks.id
}

resource "aws_security_group_rule" "pri_alb_egress_https" {
  security_group_id = aws_security_group.pri_alb.id

  type        = "egress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  source_security_group_id = aws_security_group.go_ecs_tasks.id
}

# Goコンテナのセキュリティグループ
resource "aws_security_group" "go_ecs_tasks" {
  name        = "${var.environment}-${var.app_name}-go-ecs-tasks-sg"
  description = "Security Group for Go ECS Tasks"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-${var.app_name}-go-ecs-tasks-sg"
  }
}

resource "aws_security_group_rule" "go_ecs_ingress_http" {
  security_group_id = aws_security_group.go_ecs_tasks.id

  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.pri_alb.id
}

resource "aws_security_group_rule" "go_ecs_ingress_https" {
  security_group_id = aws_security_group.go_ecs_tasks.id

  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.pri_alb.id
}

resource "aws_security_group_rule" "go_ecs_egress" {
  security_group_id = aws_security_group.go_ecs_tasks.id

  type        = "egress"
  from_port   = 3306
  to_port     = 3306
  protocol    = "tcp"
  source_security_group_id = aws_security_group.aurora.id
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

resource "aws_security_group_rule" "aurora_ingress" {
  security_group_id = aws_security_group.aurora.id

  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.go_ecs_tasks.id
}
