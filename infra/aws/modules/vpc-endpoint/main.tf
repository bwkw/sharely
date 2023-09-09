resource "aws_vpc_endpoint" "aurora" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.rds"
  vpc_endpoint_type = "Interface"
  
  subnet_ids = [
    var.subnet_pri2_1a_id,
    var.subnet_pri2_1c_id
  ]

  security_group_ids = var.security_group_ids

  private_dns_enabled = true

  tags = {
    Name = "${var.app_name}-${var.environment}-aurora-vpc-endpoint"
  }
}
