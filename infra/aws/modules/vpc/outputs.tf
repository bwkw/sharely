output "id" {
  description = "The ID of the VPC"
  value = aws_vpc.main.id
}

output "subnet_ids" {
  description = "List of subnet IDs"
  value = {
    for key, subnet in aws_subnet.common : key => subnet.id
  }
}

output "security_group_ids" {
  description = "List of security group IDs"
  value = {
    pub_alb                      = aws_security_group.pub_alb.id,
    frontend_ecs_tasks           = aws_security_group.frontend_ecs_tasks.id
    pri_alb                      = aws_security_group.pri_alb.id,
    backend_ecs_tasks            = aws_security_group.backend_ecs_tasks.id
    aurora                       = aws_security_group.aurora.id,
    secrets_manager_vpc_endpoint = aws_security_group.secrets_manager_vpc_endpoint.id,
    ecr_vpc_endpoint             = aws_security_group.ecr_vpc_endpoint.id
  }
}
