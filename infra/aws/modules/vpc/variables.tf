variable "app_name" {
  description = "Application name"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., 'stg', 'prod')"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
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

variable "pub_sub_1a_cidr" {
  description = "CIDR block for the public subnet in AZ 1a"
  type        = string
}

variable "pub_sub_1c_cidr" {
  description = "CIDR block for the public subnet in AZ 1c"
  type        = string
}

variable "pri1_sub_1a_cidr" {
  description = "CIDR block for the first private subnet in AZ 1a"
  type        = string
}

variable "pri2_sub_1a_cidr" {
  description = "CIDR block for the second private subnet in AZ 1a"
  type        = string
}

variable "pri1_sub_1c_cidr" {
  description = "CIDR block for the first private subnet in AZ 1c"
  type        = string
}

variable "pri2_sub_1c_cidr" {
  description = "CIDR block for the second private subnet in AZ 1c"
  type        = string
}

