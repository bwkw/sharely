module "vpc" {
  source = "../../modules/vpc"

  environment = var.environment
  app_name    = var.app_name

  vpc_cidr = var.vpc_cidr

  availability_zone_a = var.availability_zone_a
  availability_zone_c = var.availability_zone_c

  pub_sub_1a_cidr = var.pub_sub_1a_cidr
  pub_sub_1c_cidr = var.pub_sub_1c_cidr

  pri1_sub_1a_cidr = var.pri1_sub_1a_cidr
  pri2_sub_1a_cidr = var.pri2_sub_1a_cidr
  pri1_sub_1c_cidr = var.pri1_sub_1c_cidr
  pri2_sub_1c_cidr = var.pri2_sub_1c_cidr
  allow_ip_list    = var.allow_ip_list
}

module "secrets_manager" {
  source = "../../modules/secrets-manager"

  environment = var.environment
  app_name    = var.app_name

  db_username = var.db_username
  db_password = var.db_password
}

# module "vpc_endpoint" {
#   source = "../../modules/vpc-endpoint"

#   environment = var.environment
#   app_name    = var.app_name

#   region             = var.region
#   vpc_id             = module.vpc.vpc_id
#   subnet_pri2_1a_id  = module.vpc.subnet_pri2_1a_id
#   subnet_pri2_1c_id  = module.vpc.subnet_pri2_1c_id
#   security_group_ids = [module.vpc.aurora]
# }

module "aurora" {
  source = "../../modules/aurora"

  environment = var.environment
  app_name    = var.app_name

  vpc_id              = module.vpc.vpc_id
  availability_zone_a = var.availability_zone_a
  availability_zone_c = var.availability_zone_c
  subnet_pri2_1a_id   = module.vpc.subnet_pri2_1a_id
  subnet_pri2_1c_id   = module.vpc.subnet_pri2_1c_id
  security_group_ids  = [module.vpc.aurora_sg_id]

  instance_class = var.instance_class
  db_username    = var.db_username
  db_password    = var.db_password
}

module "alb" {
  source = "../../modules/alb"

  environment = var.environment
  app_name    = var.app_name

  vpc_id         = module.vpc.vpc_id
  pub_subnet_ids = [module.vpc.subnet_pub_1a_id, module.vpc.subnet_pub_1c_id]
  pub_alb_sg_id  = [module.vpc.pub_alb_sg_id]
}

module "ecr" {
  source = "../../modules/ecr"

  environment = var.environment
}

module "ecs" {
  source = "../../modules/ecs"

  environment = var.environment
  app_name    = var.app_name

  subnets_next_js         = [module.vpc.subnet_pri1_1a_id, module.vpc.subnet_pri1_1c_id]
  subnets_go              = [module.vpc.subnet_pri1_1a_id, module.vpc.subnet_pri1_1c_id]
  next_js_ecs_tasks_sg_id = module.vpc.next_js_ecs_tasks_sg_id
  go_ecs_tasks_sg_id      = module.vpc.go_ecs_tasks_sg_id

  next_js_image_url = module.ecr.next_js_repository_url
  go_image_url      = module.ecr.go_repository_url

  pub_alb_tg_arn = module.alb.pub_alb_tg_arn

  desired_count             = var.desired_count
  task_cpu                  = var.task_cpu
  task_memory               = var.task_memory
  cpu_scale_up_target_value = var.cpu_scale_up_target_value
  scale_out_cooldown        = var.scale_out_cooldown
  scale_in_cooldown         = var.scale_in_cooldown
  autoscaling_min_capacity  = var.autoscaling_min_capacity
  autoscaling_max_capacity  = var.autoscaling_max_capacity
}
