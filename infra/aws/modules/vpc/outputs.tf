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
    vpc_endpoint_secrets_manager = aws_security_group.vpc_endpoint_secrets_manager.id,
    vpc_endpoint_ecr_api         = aws_security_group.vpc_endpoint_ecr_api.id
    vpc_endpoint_ecr_dkr         = aws_security_group.vpc_endpoint_ecr_dkr.id
  }
}
