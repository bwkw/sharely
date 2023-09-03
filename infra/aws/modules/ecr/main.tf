locals {
  apps = {
    next_js = {
      name: "next-js-front-app",
      description: "Keep only 10 images for Next.js frontend app"
    },
    go = {
      name: "go-backend-app",
      description: "Keep only 10 images for Go backend app"
    }
  }
}

resource "aws_ecr_repository" "app" {
  for_each = local.apps

  name = each.value.name

  tags = {
    Name        = each.value.name
    Environment = var.environment
  }
}

resource "aws_ecr_lifecycle_policy" "app" {
  for_each = local.apps

  repository = aws_ecr_repository.app[each.key].name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = each.value.description
        selection = {
          tagStatus   = "untagged"
          countType  = "imageCountMoreThan"
          countNumber = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
