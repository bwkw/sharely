resource "aws_secretsmanager_secret" "aurora_credentials" {
  name = "${var.environment}-${var.app_name}-aurora-credentials"

  tags = {
    Environment = var.environment
    Application = var.app_name
  }
}

resource "aws_secretsmanager_secret_version" "aurora_credentials_version" {
  secret_id     = aws_secretsmanager_secret.aurora_credentials.id
  secret_string = "{\"username\":\"${var.db_username}\", \"password\":\"${var.db_password}\"}"
}
