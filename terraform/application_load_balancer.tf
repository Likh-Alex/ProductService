resource "aws_alb" "application_load_balancer" {
  name            = "product-service-load-balancer"
  security_groups = [aws_security_group.application_load_balancer.id]
  subnets         = aws_subnet.public.*.id
}