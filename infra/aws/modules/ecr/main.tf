resource "aws_ecr_repository" "next_js" {
  name = "next-js-front-app"

  tags = {
    Name        = "next-js-front-app"
    Environment = var.environment
  }
}

resource "aws_ecr_repository" "go" {
  name = "go-backend-app"

  tags = {
    Name        = "go-backend-app"
    Environment = var.environment
  }
}

resource "aws_ecr_lifecycle_policy" "next_js" {
  repository = aws_ecr_repository.next_js.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep only 10 images"
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

resource "aws_ecr_lifecycle_policy" "go" {
  repository = aws_ecr_repository.go.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep only 10 images"
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
