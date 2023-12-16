terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.13"
    }
  }
}

locals {
  common_name_prefix = "${var.app_name}-${var.environment}"

  task_definitions = {
    "frontend" = {
      image_url             = var.images.url.frontend
      image_tag             = var.images.tag.frontend
      container_name_suffix = "next-js-container"
      subnet_ids            = var.task.subnet_ids.frontend
      security_group_ids    = var.task.security_group_ids.frontend
      target_group_arn      = var.alb_target_group_arns.pub
    }
    "backend" = {
      image_url             = var.images.url.backend
      image_tag             = var.images.tag.backend
      container_name_suffix = "go-container"
      subnet_ids            = var.task.subnet_ids.backend
      security_group_ids    = var.task.security_group_ids.backend
      target_group_arn      = var.alb_target_group_arns.pri
    }
  }
}

resource "aws_ecs_cluster" "main" {
  name = "${var.app_name}-${var.environment}-cluster"

  tags = {
    Name = "${local.common_name_prefix}-ecs-cluster"
  }
}

resource "aws_iam_role" "ecs_execution_role" {
  name               = "${var.app_name}-${var.environment}-ecs-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Effect = "Allow",
      }
    ]
  })

  tags = {
    Name = "${local.common_name_prefix}-ecs-execution-role"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_attachments" {
  for_each = {
    task_execution = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
    ecr_read       = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  }

  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = each.value
}

resource "aws_ecs_service" "common" {
  for_each = local.task_definitions

  name            = "${each.key}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.common[each.key].arn
  launch_type     = "FARGATE"
  desired_count   = var.task.desired_count

  network_configuration {
    subnets          = each.value.subnet_ids
    security_groups  = each.value.security_group_ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = each.value.target_group_arn
    container_name   = "${var.app_name}-${var.environment}-${each.value.container_name_suffix}"
    container_port   = 80
  }

  tags = {
    Name = "${local.common_name_prefix}-ecs-service"
  }
}

resource "aws_ecs_task_definition" "common" {
  for_each = local.task_definitions

  family                   = "${each.key}-task-definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task.cpu
  memory                   = var.task.memory
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  container_definitions = jsonencode([{
    name  = "${var.app_name}-${var.environment}-${each.value.container_name_suffix}"
    image = "${each.value.image_url}:${each.value.image_tag}"
    memory = 512
    portMappings = [{
      containerPort = 80
      hostPort      = 80
    }]
  }])
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture = "ARM64"
  }

  tags = {
    Name = "${local.common_name_prefix}-ecs-task-definition"
  }
}

resource "aws_appautoscaling_target" "common" {
  for_each = local.task_definitions

  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.main.name}/${each.key}-service"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity = var.autoscaling.min_capacity
  max_capacity = var.autoscaling.max_capacity

  depends_on = [aws_ecs_service.common]
}

resource "aws_appautoscaling_policy" "common" {
  for_each = local.task_definitions

  name               = "cpu-scale-up"
  service_namespace  = "ecs"
  scalable_dimension = "ecs:service:DesiredCount"
  resource_id        = "service/${aws_ecs_cluster.main.name}/${each.key}-service"
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    target_value       = var.autoscaling.cpu_scale_up_target_value
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    scale_out_cooldown = var.autoscaling.scale_out_cooldown
    scale_in_cooldown  = var.autoscaling.scale_in_cooldown
  }

  depends_on = [aws_ecs_service.common]
}
