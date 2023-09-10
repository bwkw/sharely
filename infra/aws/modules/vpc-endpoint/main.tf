resource "aws_vpc_endpoint" "secrets_manager" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.rds"
  vpc_endpoint_type = "Interface"
  subnet_ids = var.pri1_sub_ids
  security_group_ids = var.security_group_ids

  private_dns_enabled = true

  tags = {
    Name = "${var.app_name}-${var.environment}-secrets-manager-vpc-endpoint"
  }
}
