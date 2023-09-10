variable "app_name" {
  description = "Application name"
  type        = string
  default     = "sharely"
}

variable "environment" {
  description = "Environment name (e.g., 'stg', 'prod')"
  type        = string
  default     = "stg"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "192.168.0.0/24"
}

variable "availability_zone_a" {
  description = "Availability Zone for the 1a subnet"
  type        = string
  default     = "ap-northeast-1a"
}

variable "availability_zone_c" {
  description = "Availability Zone for the 1c subnet"
  type        = string
  default     = "ap-northeast-1c"
}

variable "pub_sub_1a_cidr" {
  description = "CIDR block for the public subnet in AZ 1a"
  type        = string
  default     = "192.168.0.0/28"
}

variable "pub_sub_1c_cidr" {
  description = "CIDR block for the public subnet in AZ 1a"
  type        = string
  default     = "192.168.0.16/28"
}

variable "pri1_sub_1a_cidr" {
  description = "CIDR block for the first private subnet in AZ 1a"
  type        = string
  default     = "192.168.0.32/28"
}

variable "pri2_sub_1a_cidr" {
  description = "CIDR block for the second private subnet in AZ 1a"
  type        = string
  default     = "192.168.0.48/28"
}

variable "pri1_sub_1c_cidr" {
  description = "CIDR block for the first private subnet in AZ 1c"
  type        = string
  default     = "192.168.0.64/28"
}

variable "pri2_sub_1c_cidr" {
  description = "CIDR block for the second private subnet in AZ 1c"
  type        = string
  default     = "192.168.0.80/28"
}

variable "allow_ip_list" {
  description = "List of allowed IPs for security group ingress"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "db_username" {
  description = "The database username"
  type        = string
}

variable "db_password" {
  description = "The database password"
  type        = string
  sensitive   = true
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.t4g.medium"
}

variable "desired_count" {
  description = "The desired number of tasks for the ECS service"
  type        = number
  default     = 2
}

variable "task_cpu" {
  description = "The amount of CPU to allocate to the task"
  type        = string
  default     = "256" # 0.25 vCPU
}

variable "task_memory" {
  description = "The amount of memory to allocate to the task"
  type        = string
  default     = "512"
}

variable "cpu_scale_up_target_value" {
  description = "Target value for CPU utilization to trigger scale up."
  type        = number
  default     = 80
}

variable "scale_out_cooldown" {
  description = "Cooldown period (in seconds) after a scale-out activity completes."
  type        = number
  default     = 60
}

variable "scale_in_cooldown" {
  description = "Cooldown period (in seconds) after a scale-in activity completes."
  type        = number
  default     = 300
}

variable "autoscaling_min_capacity" {
  description = "Minimum capacity for application autoscaling."
  type        = number
  default     = 1
}

variable "autoscaling_max_capacity" {
  description = "Maximum capacity for application autoscaling."
  type        = number
  default     = 2
}