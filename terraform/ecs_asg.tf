resource "aws_autoscaling_group" "ecs_autoscaling_group" {
  desired_capacity     = 1
  max_size             = 3
  min_size             = 1
  vpc_zone_identifier  = var.vpc_subnet_ids
  launch_configuration = aws_launch_configuration.ecs_launch_configuration.name

  tag {
    key                 = "Name"
    value               = "ECS Instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "ecs-cluster"
    value               = aws_ecs_cluster.product_service_cluster.name
    propagate_at_launch = true
  }

  health_check_type         = "EC2" # Use EC2 for health checks
  force_delete              = true
  wait_for_capacity_timeout = "0"
}
