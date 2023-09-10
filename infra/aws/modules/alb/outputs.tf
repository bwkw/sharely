output "pub_alb_tg_arn" {
  description = "The ARN of the public ALB target group for the ECS service"
  value       = aws_lb_target_group.pub_alb.arn
}

output "pri_alb_tg_arn" {
  description = "The ARN of the private ALB target group for the ECS service"
  value       = aws_lb_target_group.pri_alb.arn
}
