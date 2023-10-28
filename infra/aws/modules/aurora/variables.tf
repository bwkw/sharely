variable "app_name" {
  description = "Application name"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., 'stg', 'prod')"
  type        = string
}

variable "az" {
  description = "The availability zones for the subnets."
  type = object({
    a = string
    c = string
  })
}

variable "pri2_sub_ids" {
  description = "List of primary subnet IDs"
  type        = list(string)
}

variable "sg_ids" {
  description = "List of security group IDs to associate with Aurora"
  type        = list(string)
}

variable "database" {
  description = "Database configuration"
  type = object({
    instance_class = string
    db_username    = string
    db_password    = string
  })
  sensitive   = true
}
