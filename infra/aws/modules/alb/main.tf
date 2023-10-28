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
}

resource "aws_lb" "pub_alb" {
  name               = "${local.common_name_prefix}-pub-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.alb_security_group_ids.pub
  subnets            = var.alb_subnet_ids.pub

  enable_deletion_protection = false

  tags = {
    Name = "${local.common_name_prefix}-pub-alb"
  }
}

resource "aws_lb_listener" "pub_http" {
  load_balancer_arn = aws_lb.pub_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pub_alb.arn
  }
}

resource "aws_lb_target_group" "pub_alb" {
  name     = "${local.common_name_prefix}-pub-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb" "pri_alb" {
  name               = "${local.common_name_prefix}-pri-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = var.alb_security_group_ids.pri1
  subnets            = var.alb_subnet_ids.pri1

  enable_deletion_protection = false

  tags = {
    Name = "${local.common_name_prefix}-pri-alb"
  }
}

resource "aws_lb_listener" "pri_http" {
  load_balancer_arn = aws_lb.pri_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pri_alb.arn
  }
}

resource "aws_lb_target_group" "pri_alb" {
  name     = "${local.common_name_prefix}-pri-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}
