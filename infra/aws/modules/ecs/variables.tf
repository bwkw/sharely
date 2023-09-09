variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "task_family" {
  description = "Name of the task definition family"
  type        = string
}

variable "task_cpu" {
  description = "The amount of CPU used by the task"
  type        = string
}

variable "task_memory" {
  description = "The amount of memory used by the task"
  type        = string
}

variable "ecs_execution_role_arn" {
  description = "The ARN of the ECS execution role"
  type        = string
}

variable "container_name" {
  description = "Name of the container"
  type        = string
}

variable "container_image" {
  description = "Image of the container"
  type        = string
}
