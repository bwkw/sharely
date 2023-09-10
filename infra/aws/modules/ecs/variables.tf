variable "environment" {
  description = "The environment where the ECS service will be deployed (e.g., dev, staging, prod)"
  type        = string
}

variable "app_name" {
  description = "Name of the application"
  type        = string
}

variable "desired_count" {
  description = "The desired number of instantiations of the specified task definition to keep running on the service"
  type        = number
}

variable "task_cpu" {
  description = "The amount of CPU used by the task"
  type        = string
}

variable "task_memory" {
  description = "The amount of memory used by the task"
  type        = string
}

variable "next_js_ecs_tasks_sub_ids" {
  description = "List of subnet IDs for deploying the Next.js application in ECS"
  type        = list(string)
}

variable "go_ecs_tasks_sub_ids" {
  description = "List of subnet IDs for deploying the Go application in ECS"
  type        = list(string)
}

variable "next_js_ecs_tasks_sg_ids" {
  description = "List of security group IDs for deploying the Next.js application in ECS"
  type        = list(string)
}

variable "go_ecs_tasks_sg_ids" {
  description = "List of security group IDs for deploying the Go application in ECS"
  type        = list(string)
}

variable "next_js_image_url" {
  description = "ECR URL for the Next.js application"
  type        = string
}

variable "go_image_url" {
  description = "ECR URL for the Go application"
  type        = string
}

variable "cpu_scale_up_target_value" {
  description = "Target value for CPU utilization to trigger scale up."
  type        = number
}

variable "scale_out_cooldown" {
  description = "Cooldown period (in seconds) after a scale-out activity completes."
  type        = number
}

variable "scale_in_cooldown" {
  description = "Cooldown period (in seconds) after a scale-in activity completes."
  type        = number
}

variable "autoscaling_min_capacity" {
  description = "Minimum capacity for application autoscaling."
  type        = number
}

variable "autoscaling_max_capacity" {
  description = "Maximum capacity for application autoscaling."
  type        = number
}

variable "pub_alb_tg_arn" {
  description = "The ARN of the public ALB target group for the ECS service"
  type        = string
}

variable "pri_alb_tg_arn" {
  description = "The ARN of the private ALB target group for the ECS service"
  type        = string
}
