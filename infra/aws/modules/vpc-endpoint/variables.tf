variable "environment" {
  description = "Environment name (e.g., 'stg', 'prod')"
  default     = "stg"
}

variable "app_name" {
  description = "Application name"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnet_pri2_1a_id" {
  description = "ID of the second created private subnet in AZ 1a"
  type        = string
}

variable "subnet_pri2_1c_id" {
  description = "ID of the second created private subnet in AZ 1c"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs to be associated with the VPC endpoint"
  type        = list(string)
}
