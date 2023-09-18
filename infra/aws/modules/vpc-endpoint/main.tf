resource "aws_vpc_endpoint" "secrets_manager" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.rds"
  vpc_endpoint_type = "Interface"
  subnet_ids = var.pri1_sub_ids
  security_group_ids = var.secrets_manager_vpc_endpoint_sg_ids

  private_dns_enabled = true

  tags = {
    Name = "${var.app_name}-${var.environment}-secrets-manager-vpc-endpoint"
  }
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.pri1_sub_ids

  security_group_ids  = var.ecr_vpc_endpoint_sg_ids

  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.pri1_sub_ids

  security_group_ids  = var.ecr_vpc_endpoint_sg_ids

  private_dns_enabled = true
}
