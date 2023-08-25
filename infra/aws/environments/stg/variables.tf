variable "environment" {
  default = "stg"
}

variable "app_name" {
  default = "sharely"
}

variable "vpc_cidr" {
  default = "192.168.0.0/24"
}

variable "availability_zone_a" {
  default = "ap-northeast-1a"
}

variable "availability_zone_c" {
  default = "ap-northeast-1c"
}

variable "pub_sub_1a_cidr" {
  default = "192.168.0.0/28"
}

variable "pub_sub_1c_cidr" {
  default = "192.168.0.16/28"
}

variable "pri1_sub_1a_cidr" {
  default = "192.168.0.32/28"
}

variable "pri2_sub_1a_cidr" {
  default = "192.168.0.48/28"
}

variable "pri1_sub_1c_cidr" {
  default = "192.168.0.64/28"
}

variable "pri2_sub_1c_cidr" {
  default = "192.168.0.80/28"
}

variable "allow_ip_list" {
  default = ["0.0.0.0/0"]
}
