resource "aws_secretsmanager_secret" "aurora_credentials" {
  name = "${var.environment}-${var.app_name}-aurora-credentials"

  tags = {
    Environment = var.environment
    Application = var.app_name
  }

#   普通に消してしまうと復元待機期間に引っかかってしまうので消さないように
#   lifecycle {
#     prevent_destroy = true
#   }

#   消したい場合は、復元待機期間を無視するように
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "aurora_credentials_version" {
  secret_id     = aws_secretsmanager_secret.aurora_credentials.id
  secret_string = "{\"username\":\"${var.db_username}\", \"password\":\"${var.db_password}\"}"
}
