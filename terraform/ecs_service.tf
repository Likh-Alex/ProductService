# Create a ECS service
resource "aws_ecs_service" "product_service" {
  name                               = "product_service"
  iam_role                           = aws_iam_role.ecs_service_role.arn
  cluster                            = aws_ecs_cluster.product_service_cluster.id
  task_definition                    = aws_ecs_task_definition.product_service.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = var.ecs_task_deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.ecs_task_deployment_maximum_percent

  load_balancer {
    target_group_arn = aws_alb_target_group.tg_product_service.arn
    container_name   = ""
    container_port   = 0
  }

  # Spread tasks across availability zones
  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  # Place tasks on instances with the least amount of running tasks
  ordered_placement_strategy {
    type  = "binpack"
    field = "memory"
  }
}