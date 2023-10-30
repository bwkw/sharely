variable "app_name" {
  description = "Name of the application"
  type        = string
}

variable "environment" {
  description = "The environment where the ECS service will be deployed (e.g., dev, staging, prod)"
  type        = string
}

variable "ecr_repository_arns" {
  description = "List of ECR repository ARNs"
  type        = list(string)
}

variable "oidc_thumbprint" {
  description = "Thumbprint of the OIDC provider"
  type        = string
}

variable "github_actions" {
  description = "Github Actions related configurations"
  type = object({
    repository = string
    branch     = string
  })
}

variable "sts_audience" {
  description = "Audience of the OIDC provider"
  type        = string
}
