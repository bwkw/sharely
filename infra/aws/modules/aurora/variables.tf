variable "app_name" {
  description = "Application name"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., 'stg', 'prod')"
  type        = string
}

variable "az_a" {
  description = "Availability Zone for the 1a subnet"
  type        = string
}

variable "az_c" {
  description = "Availability Zone for the 1c subnet"
  type        = string
}

variable "pri2_sub_ids" {
  description = "List of primary subnet IDs"
  type        = list(string)
}

variable "sg_ids" {
  description = "List of security group IDs to associate with Aurora"
  type        = list(string)
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
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
