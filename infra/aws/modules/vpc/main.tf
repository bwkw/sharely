terraform {
  required_version = ">= 0.13"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.13"
    }
  }
}

locals {
  common_name_prefix = "${var.app_name}-${var.environment}"

  subnets = {
    pub_1a = {
      cidr_block              = var.pub_subnets.a
      availability_zone       = var.az.a
      map_public_ip_on_launch = true
      subnet_type             = "public"
    },
    pub_1c = {
      cidr_block              = var.pub_subnets.c
      availability_zone       = var.az.c
      map_public_ip_on_launch = true
      subnet_type             = "public"
    },
    pri1_1a = {
      cidr_block              = var.pri1_subnets.a
      availability_zone       = var.az.a
      map_public_ip_on_launch = false
      subnet_type             = "private"
    },
    pri1_1c = {
      cidr_block              = var.pri1_subnets.c
      availability_zone       = var.az.c
      map_public_ip_on_launch = false
      subnet_type             = "private"
    },
    pri2_1a = {
      cidr_block              = var.pri2_subnets.a
      availability_zone       = var.az.a
      map_public_ip_on_launch = false
      subnet_type             = "private"
    },
    pri2_1c = {
      cidr_block              = var.pri2_subnets.c
      availability_zone       = var.az.c
      map_public_ip_on_launch = false
      subnet_type             = "private"
    }
  }

  route_table_associations = {
    pub = ["pub_1a", "pub_1c"],
    pri = ["pri1_1a", "pri1_1c", "pri2_1a", "pri2_1c"]
  }
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${local.common_name_prefix}-vpc"
  }
}

resource "aws_subnet" "common" {
  for_each = local.subnets

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.map_public_ip_on_launch

  tags = {
    Name = "${local.common_name_prefix}-${each.key}-sub"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name = "${local.common_name_prefix}-igw"
  }
}

resource "aws_route_table" "pub" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  
  tags = {
    Name = "${local.common_name_prefix}-pub-rt"
  }
}

resource "aws_route_table" "pri" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name = "${local.common_name_prefix}-pri-rt"
  }
}

resource "aws_route_table_association" "pub" {
  for_each = toset(local.route_table_associations.pub)

  subnet_id      = aws_subnet.common[each.key].id
  route_table_id = aws_route_table.pub.id
}

resource "aws_route_table_association" "pri" {
  for_each = toset(local.route_table_associations.pri)

  subnet_id      = aws_subnet.common[each.key].id
  route_table_id = aws_route_table.pri.id
}

# パブリックALBのセキュリティグループ
resource "aws_security_group" "pub_alb" {
  name        = "${local.common_name_prefix}-pub-alb-sg"
  description = "Security Group for Public ALB"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${local.common_name_prefix}-pub-alb-sg"
  }
}

resource "aws_security_group_rule" "pub_alb_ingress_http_from_internet" {
  security_group_id = aws_security_group.pub_alb.id

  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "pub_alb_ingress_https_from_internet" {
  security_group_id = aws_security_group.pub_alb.id

  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "pub_alb_egress_http_to_next_js_ecs_tasks" {
  security_group_id = aws_security_group.pub_alb.id

  type        = "egress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  source_security_group_id = aws_security_group.next_js_ecs_tasks.id
}

resource "aws_security_group_rule" "pub_alb_egress_https_to_next_js_ecs_tasks" {
  security_group_id = aws_security_group.pub_alb.id

  type        = "egress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  source_security_group_id = aws_security_group.next_js_ecs_tasks.id
}

# Next.jsコンテナのセキュリティグループ
resource "aws_security_group" "next_js_ecs_tasks" {
  name        = "${local.common_name_prefix}-next-js-ecs-tasks-sg"
  description = "Security Group for Next.js ECS Tasks"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${local.common_name_prefix}-next-js-ecs-tasks-sg"
  }
}

resource "aws_security_group_rule" "next_js_ecs_tasks_ingress_http_from_pub_alb" {
  security_group_id = aws_security_group.next_js_ecs_tasks.id

  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.pub_alb.id
}

resource "aws_security_group_rule" "next_js_ecs_tasks_ingress_https_from_pub_alb" {
  security_group_id = aws_security_group.next_js_ecs_tasks.id

  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.pub_alb.id
}

resource "aws_security_group_rule" "next_js_ecs_tasks_egress_http_to_pri_alb" {
  security_group_id = aws_security_group.next_js_ecs_tasks.id

  type        = "egress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  source_security_group_id = aws_security_group.pri_alb.id
}

resource "aws_security_group_rule" "next_js_ecs_tasks_egress_https_to_pri_alb" {
  security_group_id = aws_security_group.next_js_ecs_tasks.id

  type        = "egress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  source_security_group_id = aws_security_group.pri_alb.id
}

resource "aws_security_group_rule" "next_js_ecs_tasks_egress_https_to_ecr_vpc_endpoint" {
  security_group_id = aws_security_group.next_js_ecs_tasks.id

  type        = "egress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  source_security_group_id = aws_security_group.ecr_vpc_endpoint.id
}

# プライベートALBのセキュリティグループ
resource "aws_security_group" "pri_alb" {
  name        = "${local.common_name_prefix}-pri-alb-sg"
  description = "Security Group for Private ALB"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${local.common_name_prefix}-pri-alb-sg"
  }
}

resource "aws_security_group_rule" "pri_alb_ingress_http_from_next_js_ecs_tasks" {
  security_group_id = aws_security_group.pri_alb.id

  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.next_js_ecs_tasks.id
}

resource "aws_security_group_rule" "pri_alb_ingress_https_from_next_js_ecs_tasks" {
  security_group_id = aws_security_group.pri_alb.id

  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.next_js_ecs_tasks.id
}

resource "aws_security_group_rule" "pri_alb_egress_http_to_go_ecs_tasks" {
  security_group_id = aws_security_group.pri_alb.id

  type        = "egress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  source_security_group_id = aws_security_group.go_ecs_tasks.id
}

resource "aws_security_group_rule" "pri_alb_egress_https_to_go_ecs_tasks" {
  security_group_id = aws_security_group.pri_alb.id

  type        = "egress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  source_security_group_id = aws_security_group.go_ecs_tasks.id
}

# Goコンテナのセキュリティグループ
resource "aws_security_group" "go_ecs_tasks" {
  name        = "${local.common_name_prefix}-go-ecs-tasks-sg"
  description = "Security Group for Go ECS Tasks"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${local.common_name_prefix}-go-ecs-tasks-sg"
  }
}

resource "aws_security_group_rule" "go_ecs_tasks_ingress_http_from_pri_alb" {
  security_group_id = aws_security_group.go_ecs_tasks.id

  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.pri_alb.id
}

resource "aws_security_group_rule" "go_ecs_tasks_ingress_https_from_pri_alb" {
  security_group_id = aws_security_group.go_ecs_tasks.id

  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.pri_alb.id
}

resource "aws_security_group_rule" "go_ecs_tasks_egress_https_to_ecr_vpc_endpoint" {
  security_group_id = aws_security_group.go_ecs_tasks.id

  type        = "egress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  source_security_group_id = aws_security_group.ecr_vpc_endpoint.id
}

resource "aws_security_group_rule" "go_ecs_tasks_egress_https_to_secrets_manager_vpc_endpoint" {
  security_group_id = aws_security_group.go_ecs_tasks.id

  type        = "egress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  source_security_group_id = aws_security_group.secrets_manager_vpc_endpoint.id
}

resource "aws_security_group_rule" "go_ecs_tasks_egress_to_aurora" {
  security_group_id = aws_security_group.go_ecs_tasks.id

  type        = "egress"
  from_port   = 3306
  to_port     = 3306
  protocol    = "tcp"
  source_security_group_id = aws_security_group.aurora.id
}

# Auroraのセキュリティグループ
resource "aws_security_group" "aurora" {
  name        = "${local.common_name_prefix}-aurora-sg"
  description = "Security Group for both Aurora"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${local.common_name_prefix}-aurora-sg"
  }
}

resource "aws_security_group_rule" "aurora_ingress_from_go_ecs_tasks" {
  security_group_id = aws_security_group.aurora.id

  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.go_ecs_tasks.id
}

# Secrets Manager VPC Endpointのセキュリティグループ
resource "aws_security_group" "secrets_manager_vpc_endpoint" {
  name        = "${local.common_name_prefix}-secrets-manager-vpc-endpoint-sg"
  description = "Security Group for Secrets Manager VPC Endpoint"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${local.common_name_prefix}-secrets-manager-vpc-endpoint-sg"
  }
}

resource "aws_security_group_rule" "secrets_manager_vpc_endpoint_ingress_from_go_ecs_tasks" {
  security_group_id = aws_security_group.secrets_manager_vpc_endpoint.id

  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  source_security_group_id = aws_security_group.go_ecs_tasks.id
}

# ECR VPC Endpointのセキュリティグループ
resource "aws_security_group" "ecr_vpc_endpoint" {
  name        = "${local.common_name_prefix}-ecr-vpc-endpoint-sg"
  description = "Security Group for ECR VPC Endpoint"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${local.common_name_prefix}-ecr-vpc-endpoint-sg"
  }
}

resource "aws_security_group_rule" "ecr_vpc_endpoint_ingress_from_next_js_ecs_tasks" {
  security_group_id = aws_security_group.ecr_vpc_endpoint.id

  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.next_js_ecs_tasks.id
}

resource "aws_security_group_rule" "ecr_vpc_endpoint_ingress_from_go_ecs_tasks" {
  security_group_id = aws_security_group.ecr_vpc_endpoint.id

  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.go_ecs_tasks.id
}
