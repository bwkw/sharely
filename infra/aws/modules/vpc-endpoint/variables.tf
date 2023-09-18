variable "app_name" {
  description = "Application name"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., 'stg', 'prod')"
  default     = "stg"
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

variable "secrets_manager_vpc_endpoint_sg_ids" {
  description = "List of security group IDs for Secrets Manager VPC Endpoint"
  type        = list(string)
}

variable "ecr_vpc_endpoint_sg_ids" {
  description = "List of security group IDs for ECR VPC Endpoint"
  type        = list(string)
}
