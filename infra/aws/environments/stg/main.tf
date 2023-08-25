module "vpc" {
  environment = var.environment
  app_name    = var.app_name

  source   = "../../modules/vpc"
  vpc_cidr = var.vpc_cidr

  availability_zone_a = var.availability_zone_a
  availability_zone_b = var.availability_zone_b

  pub_sub_1a_cidr = var.pub_sub_1a_cidr
  pub_sub_1b_cidr = var.pub_sub_1b_cidr

  pri1_sub_1a_cidr = var.pri1_sub_1a_cidr
  pri2_sub_1a_cidr = var.pri2_sub_1a_cidr
  pri1_sub_1b_cidr = var.pri1_sub_1b_cidr
  pri2_sub_1b_cidr = var.pri2_sub_1b_cidr
  allow_ip_list    = var.allow_ip_list
}
