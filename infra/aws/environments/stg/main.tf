module "vpc" {
  source = "../../modules/vpc"

  app_name    = var.app_name
  environment = var.environment

  vpc_cidr = var.vpc_cidr

  az_a = var.az_a
  az_c = var.az_c

  pub_sub_1a_cidr = var.pub_sub_1a_cidr
  pub_sub_1c_cidr = var.pub_sub_1c_cidr

  pri1_sub_1a_cidr = var.pri1_sub_1a_cidr
  pri2_sub_1a_cidr = var.pri2_sub_1a_cidr
  pri1_sub_1c_cidr = var.pri1_sub_1c_cidr
  pri2_sub_1c_cidr = var.pri2_sub_1c_cidr
}

module "secrets_manager" {
  source = "../../modules/secrets-manager"

  app_name    = var.app_name
  environment = var.environment

  db_username = var.db_username
  db_password = var.db_password
}

module "vpc_endpoint" {
  source = "../../modules/vpc-endpoint"

  app_name    = var.app_name
  environment = var.environment

  region                              = var.region
  vpc_id                              = module.vpc.vpc_id
  pri1_sub_ids                        = [module.vpc.pri1_sub_1a_id, module.vpc.pri1_sub_1c_id]
  secrets_manager_vpc_endpoint_sg_ids = [module.vpc.secrets_manager_vpc_endpoint_sg_id]
  ecr_vpc_endpoint_sg_ids             = [module.vpc.ecr_vpc_endpoint_sg_id]
}

module "aurora" {
  source = "../../modules/aurora"

  app_name    = var.app_name
  environment = var.environment

  az_a         = var.az_a
  az_c         = var.az_c
  pri2_sub_ids = [module.vpc.pri2_sub_1a_id, module.vpc.pri2_sub_1c_id]
  sg_ids       = [module.vpc.aurora_sg_id]

  instance_class = var.instance_class
  db_username    = var.db_username
  db_password    = var.db_password
}

module "alb" {
  source = "../../modules/alb"

  environment = var.environment
  app_name    = var.app_name

  vpc_id          = module.vpc.vpc_id
  pub_sub_ids     = [module.vpc.pub_sub_1a_id, module.vpc.pub_sub_1c_id]
  pub_alb_sg_ids  = [module.vpc.pub_alb_sg_id]
  pri1_sub_ids    = [module.vpc.pri1_sub_1a_id, module.vpc.pri1_sub_1c_id]
  pri1_alb_sg_ids = [module.vpc.pri_alb_sg_id]
}

module "ecr" {
  source = "../../modules/ecr"

  app_name    = var.app_name
  environment = var.environment

  ecs_execution_role_arn = module.ecs.ecs_execution_role_arn
}

module "ecs" {
  source = "../../modules/ecs"

  app_name    = var.app_name
  environment = var.environment

  ecs_tasks_sub_ids = {
    next_js = [module.vpc.pri1_sub_1a_id, module.vpc.pri1_sub_1c_id],
    go      = [module.vpc.pri1_sub_1a_id, module.vpc.pri1_sub_1c_id]
  }
  ecs_tasks_sg_ids = {
    next_js = [module.vpc.next_js_ecs_tasks_sg_id],
    go      = [module.vpc.go_ecs_tasks_sg_id]
  }

  next_js_image_url = module.ecr.next_js_repository_url
  go_image_url      = module.ecr.go_repository_url

  pub_alb_tg_arn = module.alb.pub_alb_tg_arn
  pri_alb_tg_arn = module.alb.pri_alb_tg_arn

  desired_count             = var.desired_count
  task_cpu                  = var.task_cpu
  task_memory               = var.task_memory
  cpu_scale_up_target_value = var.cpu_scale_up_target_value
  scale_out_cooldown        = var.scale_out_cooldown
  scale_in_cooldown         = var.scale_in_cooldown
  autoscaling_min_capacity  = var.autoscaling_min_capacity
  autoscaling_max_capacity  = var.autoscaling_max_capacity
}
