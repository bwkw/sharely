resource "aws_lb" "pub_alb" {
  name               = "${var.environment}-${var.app_name}-pub-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.pub_alb_sg_id
  subnets            = var.pub_subnet_ids

  enable_deletion_protection = false

  tags = {
    Name = "${var.environment}-${var.app_name}-pub-alb"
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.pub_alb.arn
  port              = 80
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pub_alb_tg.arn
  }
}

resource "aws_lb_target_group" "pub_alb_tg" {
  name     = "${var.app_name}-${var.environment}-pub-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

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
