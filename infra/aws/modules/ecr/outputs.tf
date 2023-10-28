output "repository_urls" {
  value = {
    for key, ecr_repository in aws_ecr_repository.common : key => ecr_repository.repository_url
  }
}

output "repository_arns" {
  value = {
    for key, ecr_repository in aws_ecr_repository.common : key => ecr_repository.arn
  }
}
