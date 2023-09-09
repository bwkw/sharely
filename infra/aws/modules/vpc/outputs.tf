output "vpc_id" {
  value       = aws_vpc.main.id
  description = "ID of the created VPC"
}

output "subnet_pub_1a_id" {
  value       = aws_subnet.pub_1a.id
  description = "ID of the first created public subnet in AZ 1a"
}

output "subnet_pub_1c_id" {
  value       = aws_subnet.pub_1c.id
  description = "ID of the first created public subnet in AZ 1c"
}

output "subnet_pri1_1a_id" {
  value       = aws_subnet.pri1_1a.id
  description = "ID of the first created private subnet in AZ 1a"
}

output "subnet_pri1_1c_id" {
  value       = aws_subnet.pri1_1c.id
  description = "ID of the first created private subnet in AZ 1c"
}

output "subnet_pri2_1a_id" {
  value       = aws_subnet.pri2_1a.id
  description = "ID of the second created private subnet in AZ 1a"
}

output "subnet_pri2_1c_id" {
  value       = aws_subnet.pri2_1c.id
  description = "ID of the second created private subnet in AZ 1c"
}

output "pub_alb_sg_id" {
  description = "The ID of the security group for Public ALB"
  value       = aws_security_group.pub_alb.id
}

output "next_js_ecs_tasks_sg_id" {
  description = "The ID of the security group for Next.js ECS Tasks"
  value       = aws_security_group.next_js_ecs_tasks.id
}

output "pri_alb_sg_id" {
  description = "The ID of the security group for Private ALB"
  value       = aws_security_group.pri_alb.id
}

output "go_ecs_tasks_sg_id" {
  description = "The ID of the security group for Go ECS Tasks"
  value       = aws_security_group.go_ecs_tasks.id
}

output "aurora_sg_id" {
  description = "The ID of the security group for Aurora"
  value       = aws_security_group.aurora.id
}
