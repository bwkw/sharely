variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "pub_sub_1a_cidr" {
  description = "CIDR block for the public subnet in AZ 1a"
  type        = string
}

variable "availability_zone_a" {
  description = "Availability Zone for the 1a subnet"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., 'stg', 'prod')"
  type        = string
}

variable "app_name" {
  description = "Application name"
  type        = string
}

variable "allow_ip_list" {
  description = "List of allowed IPs for security group ingress"
  type        = list(string)
}
