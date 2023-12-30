resource "aws_ecs_capacity_provider" "main_ecs_capacity_provider" {
  name = 'main_ecs_capacity_provider'

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs_autoscaling_group.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      maximum_scaling_step_size = var.max_scaling_step_size
      minimum_scaling_step_size = var.min_scaling_step_size
      status                    = "ENABLED"
      target_capacity           = var.target_capacity
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "cas" {
  cluster_name       = aws_ecs_cluster.product_service_cluster.name
  capacity_providers = [aws_ecs_capacity_provider.main_ecs_capacity_provider.name]
}