variable "app_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "az" {
  type = object({
    a = string
    c = string
  })
}

variable "pub_subnets" {
  type = object({
    a = string
    c = string
  })
}

variable "pri1_subnets" {
  type = object({
    a = string
    c = string
  })
}

variable "pri2_subnets" {
  type = object({
    a = string
    c = string
  })
}
