variable "environment" {
  description = "The environment where infrastructure is deployed, e.g., 'dev', 'stg', 'prod'."
  type        = string
}

variable "app_name" {
  description = "The name of the application."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where resources will be deployed."
  type        = string
}

variable "pub_alb_sg_id" {
  description = "Security Group ID for the public Application Load Balancer."
  type        = list(string)
}

variable "pub_subnet_ids" {
  description = "List of subnet IDs for the public Application Load Balancer."
  type        = list(string)
}

variable "pri_alb_sg_id" {
  description = "Security Group ID for the private Application Load Balancer."
  type        = list(string)
}

variable "pri_subnet_ids" {
  description = "List of subnet IDs for the private Application Load Balancer."
  type        = list(string)
}
