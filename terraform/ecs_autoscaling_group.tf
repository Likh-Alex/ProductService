resource "aws_autoscaling_group" "ecs_autoscaling_group" {
  name                  = "${var.namespace}-ecs-autoscaling-group-${var.environment}"
  max_size              = "${var.autoscaling_max_size}"
  min_size              = "${var.autoscaling_min_size}"
  vpc_zone_identifier   = [aws_subnet.private.*.id]
  health_check_type     = "EC2"
  protect_from_scale_in = true

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances"
  ]

  launch_template {
    id      = aws_launch_template.ecs_cluster_launch_template
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  }

  instance_refresh {
    strategy = "Rolling"
  }

  tag {
    key                 = "Name"
    value               = "${var.namespace}-ecs-autoscaling-group-${var.environment}"
    propagate_at_launch = true
  }
}
