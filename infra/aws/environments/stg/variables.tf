variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "pub_sub_1a_cidr" {
  default = "10.0.1.0/24"
}

variable "availability_zone_a" {
  default = "ap-northeast-1a"
}

variable "environment" {
  default = "stg"
}

variable "app_name" {
  default = "sharely"
}

variable "allow_ip_list" {
  default = ["0.0.0.0/0"]
}
