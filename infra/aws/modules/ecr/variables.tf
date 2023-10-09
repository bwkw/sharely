variable "app_name" {
  description = "The name of the application."
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., 'stg', 'prod')"
  type        = string
}

variable "ecs_execution_role_arn" {
  description = "The ARN of the ECS execution role"
  type        = string
}
