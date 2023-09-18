locals {
  common_cluster_name = "${var.app_name}-${var.environment}-cluster"
  common_execution_role_name = "${var.app_name}-${var.environment}-ecs-execution-role"
  common_cpu = var.task_cpu
  common_memory = var.task_memory
}

resource "aws_ecs_cluster" "main" {
  name = local.common_cluster_name
}

resource "aws_iam_role" "ecs_execution_role" {
  name               = local.common_execution_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_attachments" {
  for_each = {
    task_execution = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
    ecr_read      = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  }

  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = each.value
}

resource "aws_ecs_service" "service" {
  for_each = {
    next_js = {
      task_definition = aws_ecs_task_definition.task["next_js"].arn
      alb_tg_arn = var.pub_alb_tg_arn
      container_name_suffix = "next-js-container"
    },
    go = {
      task_definition = aws_ecs_task_definition.task["go"].arn
      alb_tg_arn = var.pri_alb_tg_arn
      container_name_suffix = "go-container"
    }
  }
  name            = "${each.key}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = each.value.task_definition
  launch_type     = "FARGATE"
  desired_count   = var.desired_count

  network_configuration {
    subnets          = var.ecs_tasks_sub_ids[each.key]
    security_groups  = var.ecs_tasks_sg_ids[each.key]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = each.value.alb_tg_arn
    container_name   = "${var.app_name}-${var.environment}-${each.value.container_name_suffix}"
    container_port   = 80 
  }
}

resource "aws_ecs_task_definition" "task" {
  for_each = {
    next_js = {
      image_url = var.next_js_image_url
      container_name_suffix = "next-js-container"
    },
    go = {
      image_url = var.go_image_url
      container_name_suffix = "go-container"
    }
  }

  family                   = "${each.key}-task-definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = local.common_cpu
  memory                   = local.common_memory
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([{
    name  = "${var.app_name}-${var.environment}-${each.value.container_name_suffix}"
    image = each.value.image_url
    memory = 512
    portMappings = [{
      containerPort = 80
      hostPort      = 80
    }]
  }])
}

resource "aws_appautoscaling_target" "target" {
  for_each = {
    next_js = aws_ecs_service.service["next_js"].name
    go = aws_ecs_service.service["go"].name
  }

  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.main.name}/${each.value}"
  scalable_dimension = "ecs:service:DesiredCount"

  min_capacity = var.autoscaling_min_capacity
  max_capacity = var.autoscaling_max_capacity
}

resource "aws_appautoscaling_policy" "policy" {
  for_each = {
    next_js = aws_appautoscaling_target.target["next_js"]
    go = aws_appautoscaling_target.target["go"]
  }

  name               = "cpu-scale-up"
  service_namespace  = each.value.service_namespace
  scalable_dimension = each.value.scalable_dimension
  resource_id        = each.value.resource_id
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    target_value       = var.cpu_scale_up_target_value
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    scale_out_cooldown = var.scale_out_cooldown
    scale_in_cooldown  = var.scale_in_cooldown
  }
}
