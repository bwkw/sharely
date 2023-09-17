locals {
  apps = {
    next_js = {
      name: "${var.app_name}-${var.environment}-next-js-front-app",
      description: "Keep only 10 images for Next.js frontend app"
    },
    go = {
      name: "${var.app_name}-${var.environment}-go-backend-app",
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

resource "aws_ecr_repository_policy" "ecs" {
  for_each = local.apps
  repository = aws_ecr_repository.app[each.key].name

  policy = jsonencode({
    Version = "2008-10-17",
    Statement = [
      {
        Sid       = "AllowEcsTasksToPullImages",
        Effect    = "Allow",
        Principal = {
          AWS = var.ecs_execution_role_arn
        },
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability"
        ]
      }
    ]
  })
}
