# 共通のクラスタ
resource "aws_ecs_cluster" "main" {
  name = "${var.app_name}-${var.environment}-cluster"
}

# ECS実行ロール
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
        Sid    = ""
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_attachment" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_execution_ecr_read" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Next.js サービス定義
resource "aws_ecs_service" "next_js" {
  name            = "next-js-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.next_js.arn
  launch_type     = "FARGATE"
  desired_count   = var.desired_count

  network_configuration {
    subnets          = var.subnets_next_js
    security_groups  = [var.next_js_ecs_tasks_sg_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.pub_alb_tg_arn
    container_name   = "${var.app_name}-${var.environment}-next-js-container"
    container_port   = 80 
  }
}

# Next.js タスク定義
resource "aws_ecs_task_definition" "next_js" {
  family                   = "next-js-task-definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([{
    name  = "${var.app_name}-${var.environment}-next-js-container"
    image = var.next_js_image_url
  }])
}

# Next.js タスクのオートスケーリング
resource "aws_appautoscaling_target" "next_js" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.next_js.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  min_capacity = var.autoscaling_min_capacity
  max_capacity = var.autoscaling_max_capacity
}

resource "aws_appautoscaling_policy" "next_js_cpu_scale_up" {
  name               = "cpu-scale-up"
  service_namespace  = aws_appautoscaling_target.next_js.service_namespace
  scalable_dimension = aws_appautoscaling_target.next_js.scalable_dimension
  resource_id        = aws_appautoscaling_target.next_js.resource_id
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

# Go サービス定義
resource "aws_ecs_service" "go" {
  name            = "go-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.go.arn
  launch_type     = "FARGATE"
  desired_count   = var.desired_count

  network_configuration {
    subnets          = var.subnets_go
    security_groups  = [var.go_ecs_tasks_sg_id]
  }
}

# Go タスク定義
resource "aws_ecs_task_definition" "go" {
  family                   = "go-task-definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([{
    name  = "${var.app_name}-${var.environment}-go-container"
    image = var.go_image_url
  }])
}

# Go タスクのオートスケーリング
resource "aws_appautoscaling_target" "go" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.go.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  min_capacity = var.autoscaling_min_capacity
  max_capacity = var.autoscaling_max_capacity
}

resource "aws_appautoscaling_policy" "go_cpu_scale_up" {
  name               = "cpu-scale-up"
  service_namespace  = aws_appautoscaling_target.go.service_namespace
  scalable_dimension = aws_appautoscaling_target.go.scalable_dimension
  resource_id        = aws_appautoscaling_target.go.resource_id
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
