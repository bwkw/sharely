output "ecs_cluster_arn" {
  value       = aws_ecs_cluster.main.arn
  description = "The ARN of the ECS cluster."
}

output "next_js_task_definition_arn" {
  value       = aws_ecs_task_definition.next_js.arn
  description = "The ARN of the Next.js task definition."
}

output "go_task_definition_arn" {
  value       = aws_ecs_task_definition.go.arn
  description = "The ARN of the Go task definition."
}

output "ecs_execution_role_arn" {
  description = "The ARN of the ECS execution role"
  value       = aws_iam_role.ecs_execution_role.arn
}
