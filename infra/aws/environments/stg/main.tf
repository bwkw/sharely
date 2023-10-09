module "vpc" {
  source = "../../modules/vpc"

  app_name    = var.app_name
  environment = var.environment

  vpc_cidr     = var.vpc_cidr
  az           = var.az
  pub_subnets  = var.pub_subnets
  pri1_subnets = var.pri1_subnets
  pri2_subnets = var.pri2_subnets
}

module "secrets-manager" {
  source = "../../modules/secrets-manager"

  app_name    = var.app_name
  environment = var.environment

  db_username = var.db_username
  db_password = var.db_password
}

module "vpc-endpoint" {
  source = "../../modules/vpc-endpoint"

  app_name    = var.app_name
  environment = var.environment

  region                              = var.region
  vpc_id                              = module.vpc.vpc_id
  pri1_sub_ids                        = module.vpc.subnets["pri1"]
  secrets_manager_vpc_endpoint_sg_ids = [module.vpc.security_groups["secrets_manager_vpc_endpoint"]]
  ecr_vpc_endpoint_sg_ids             = [module.vpc.security_groups["ecr_vpc_endpoint"]]
}

module "aurora" {
  source = "../../modules/aurora"

  app_name    = var.app_name
  environment = var.environment

  az_a         = var.az.a
  az_c         = var.az.c
  pri2_sub_ids = module.vpc.subnets["pri2"]
  sg_ids       = [module.vpc.security_groups["aurora"]]

  instance_class = var.instance_class
  db_username    = var.db_username
  db_password    = var.db_password
}

module "alb" {
  source = "../../modules/alb"

  environment = var.environment
  app_name    = var.app_name

  vpc_id          = module.vpc.vpc_id
  pub_sub_ids     = module.vpc.subnets["pub"]
  pub_alb_sg_ids  = [module.vpc.security_groups["pub_alb"]]
  pri1_sub_ids    = module.vpc.subnets["pri1"]
  pri1_alb_sg_ids = [module.vpc.security_groups["pri_alb"]]
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
    next_js = module.vpc.subnets["pri1"],
    go      = module.vpc.subnets["pri1"]
  }
  ecs_tasks_sg_ids = {
    next_js = [module.vpc.security_groups["next_js_ecs_tasks"]],
    go      = [module.vpc.security_groups["go_ecs_tasks"]]
  }

  next_js_image_url = module.ecr.next_js_repository_url
  go_image_url      = module.ecr.go_repository_url

  next_js_image_tag = var.next_js_image_tag
  go_image_tag      = var.go_image_tag

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

module "oidc" {
  source = "../../modules/oidc"

  app_name    = var.app_name
  environment = var.environment

  ecr_repository_arns = module.ecr.repository_arns
  oidc_thumbprint     = var.iam_role_oidc_thumbprint
  github_actions      = var.iam_role_github_actions
  sts_audience        = var.sts_audience
}
