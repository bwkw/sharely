variable "environment" {
  description = "Environment name (e.g., 'stg', 'prod')"
  type        = string
}

variable "app_name" {
  description = "Application name"
  type        = string
}

variable "db_username" {
  description = "Username for the database"
  type        = string
}

variable "db_password" {
  description = "Password for the database"
  type        = string
  sensitive   = true
}
