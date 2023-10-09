resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = [var.sts_audience]
  thumbprint_list = [var.oidc_thumbprint]
}

resource "aws_iam_role" "github_actions" {
  name = "${var.app_name}-${var.environment}-oidc-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity",
      Effect = "Allow",
      Principal = {
        Federated = aws_iam_openid_connect_provider.github.arn
      },
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" : var.sts_audience,
          "token.actions.githubusercontent.com:sub" : "repo:${var.github_actions.repository}:ref:refs/heads/${var.github_actions.branch}"
        }
      }
    }]
  })

  tags = {
    Name = "${var.app_name}-${var.environment}-iam-role-github-actions"
  }
}

resource "aws_iam_policy" "github_actions_ecr" {
  name = "github-actions-ecr"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Action" : "ecr:GetAuthorizationToken",
        "Effect" : "Allow",
        "Resource" : "*"
      },
      {
        "Action" : [
          "ecr:UploadLayerPart",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:CompleteLayerUpload",
          "ecr:BatchCheckLayerAvailability"
        ],
        "Effect" : "Allow",
        "Resource" : var.ecr_repository_arns
      }]
  })
}

resource "aws_iam_role_policy_attachment" "github_actions_ecr" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_actions_ecr.arn
}