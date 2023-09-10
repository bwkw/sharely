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

variable "pri1_sub_ids" {
  description = "List of primary subnet IDs"
  type        = list(string)
}

variable "sg_ids" {
  description = "List of security group IDs for the Secrets Manager VPC Endpoint"
  type        = list(string)
}
