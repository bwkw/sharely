output "ecs_cluster_arn" {
  value       = aws_ecs_cluster.main.arn
  description = "The ARN of the ECS cluster."
}

output "next_js_task_definition_arn" {
  value       = aws_ecs_task_definition.task["next_js"].arn
  description = "The ARN of the next_js ECS task definition"
}

output "go_task_definition_arn" {
  value       = aws_ecs_task_definition.task["go"].arn
  description = "The ARN of the go ECS task definition"
}

output "ecs_execution_role_arn" {
  description = "The ARN of the ECS execution role"
  value       = aws_iam_role.ecs_execution_role.arn
}
