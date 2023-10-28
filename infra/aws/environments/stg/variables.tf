variable "app_name" {
  type    = string
  default = "sharely"
}

variable "environment" {
  type    = string
  default = "stg"
}

variable "region" {
  type    = string
  default = "ap-northeast-1"
}

variable "vpc_cidr" {
  type    = string
  default = "192.168.0.0/24"
}

variable "az" {
  type = object({
    a = string
    c = string
  })
  default = {
    a = "ap-northeast-1a"
    c = "ap-northeast-1c"
  }
}

variable "pub_subnets" {
  type = object({
    a = string
    c = string
  })
  default = {
    a = "192.168.0.0/28"
    c = "192.168.0.16/28"
  }
}

variable "pri1_subnets" {
  type = object({
    a = string
    c = string
  })
  default = {
    a = "192.168.0.32/28"
    c = "192.168.0.64/28"
  }
}

variable "pri2_subnets" {
  type = object({
    a = string
    c = string
  })
  default = {
    a = "192.168.0.48/28"
    c = "192.168.0.80/28"
  }
}

variable "database_secret" {
  type = object({
    db_username = string
    db_password = string
  })
  default = {
    db_username = ""
    db_password = ""
  }
  sensitive = true
}

variable "database_instance_class" {
  type    = string
  default = "db.t4g.medium"
}

variable "desired_count" {
  type    = number
  default = 2
}

variable "task_cpu" {
  type    = string
  default = "256" # 0.25 vCPU
}

variable "task_memory" {
  type    = string
  default = "512"
}

variable "next_js_image_tag" {
  type    = string
  default = "test"
}

variable "go_image_tag" {
  type    = string
  default = "test"
}

variable "cpu_scale_up_target_value" {
  type    = number
  default = 80
}

variable "scale_out_cooldown" {
  type    = number
  default = 60
}

variable "scale_in_cooldown" {
  type    = number
  default = 300
}

variable "autoscaling_min_capacity" {
  type    = number
  default = 1
}

variable "autoscaling_max_capacity" {
  type    = number
  default = 2
}

variable "iam_role_oidc_thumbprint" {
  type    = string
  default = "3EA80E902FC385F36BC08193FBC678202D572994"
}

variable "iam_role_github_actions" {
  type = object({
    repository = string
    branch     = string
  })
  default = {
    repository = "bwkw/sharely"
    branch     = "stg"
  }
}

variable "sts_audience" {
  type    = string
  default = "sts.amazonaws.com"
}
