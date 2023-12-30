resource "aws_ecs_cluster" "product_service_cluster" {
  name = "product_service-cluster"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "product_service-cluster"
  }
}
