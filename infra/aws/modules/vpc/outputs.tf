output "vpc_id" {
  value       = aws_vpc.main.id
}

output "subnets" {
  value = {
    for key, subnet in aws_subnet.common : key => subnet.id
  }
}

output "security_groups" {
  value = {
    pub_alb                     = aws_security_group.pub_alb.id,
    next_js_ecs_tasks           = aws_security_group.next_js_ecs_tasks.id,
    pri_alb                     = aws_security_group.pri_alb.id,
    go_ecs_tasks                = aws_security_group.go_ecs_tasks.id,
    aurora                      = aws_security_group.aurora.id,
    secrets_manager_vpc_endpoint = aws_security_group.secrets_manager_vpc_endpoint.id,
    ecr_vpc_endpoint            = aws_security_group.ecr_vpc_endpoint.id
  }
}
