variable "app_name" {
  type        = string
}

variable "environment" {
  type        = string
}

variable "ecr_repository_arns" {
  type = list(string)
}

variable "oidc_thumbprint" {
  type = string
}

variable "github_actions" {
  type = object({
    repository = string
    branch     = string
  })
}

variable "sts_audience" {
  type = string
}