variable "environment" {
  description = "Environment name (e.g., 'stg', 'prod')"
  type        = string
}

variable "app_name" {
  description = "Application name"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where Aurora will be placed"
  type        = string
}

variable "availability_zone_a" {
  description = "Availability Zone for the 1a subnet"
  type        = string
}

variable "availability_zone_c" {
  description = "Availability Zone for the 1c subnet"
  type        = string
}

variable "subnet_pri2_1a_id" {
  description = "ID of the second private subnet in AZ 1a"
  type        = string
}

variable "subnet_pri2_1c_id" {
  description = "ID of the second private subnet in AZ 1c"
  type        = string
}

variable "security_group_ids" {
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
