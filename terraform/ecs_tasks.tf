resource "aws_ecs_task_definition" "product_service" {
  family             = "product_service"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name   = "axonserver",
      image  = "axoniq/axonserver:latest",
      cpu    = var.cpu_units,
      memory = var.memory,
      portMappings = [
        {
          containerPort = 8024,
          hostPort      = 8024,
          protocol      = "tcp"
        }
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.product_service_log_group.name,
          "awslogs-region"        = var.region,
          "awslogs-stream-prefix" = "app"
        }
      }
    },
    {
      name   = "product_service",
      image  = "154479180857.dkr.ecr.eu-central-1.amazonaws.com/product_service_repo:latest",
      cpu    = var.cpu_units,
      memory = var.memory,
      portMappings = [
        {
          containerPort = 8081,
          hostPort      = 8081,
          protocol      = "tcp"
        }
      ],
      essential = true,
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.product_service_log_group.name,
          "awslogs-region"        = var.region,
          "awslogs-stream-prefix" = "app"
        }
      }
    }
  ])
}
