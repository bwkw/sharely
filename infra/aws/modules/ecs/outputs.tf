output "cluster_arn" {
  value       = aws_ecs_cluster.main.arn
  description = "The ARN of the ECS cluster."
}

output "task_definition_arn" {
  description = "The ARN of the  ECS task definition"
  value       = {
    frontend     = aws_ecs_task_definition.common["frontend"].arn
    backend      = aws_ecs_task_definition.common["backend"].arn
  }
}

output "execution_role_arn" {
  description = "The ARN of the ECS execution role"
  value       = aws_iam_role.ecs_execution_role.arn
}
