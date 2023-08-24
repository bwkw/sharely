module "vpc" {
  source              = "../../modules/vpc"
  vpc_cidr            = var.vpc_cidr
  pub_sub_1a_cidr     = var.pub_sub_1a_cidr
  availability_zone_a = var.availability_zone_a
  environment         = var.environment
  app_name            = var.app_name
  allow_ip_list       = var.allow_ip_list
}
