variable "app_name" {
  description = "Application name"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., 'stg', 'prod')"
  type        = string
}

variable "database" {
  description = "Database related configurations"
  type = object({
    username = string
    password = string
  })
  sensitive   = true
}
