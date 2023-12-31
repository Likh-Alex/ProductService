resource "aws_cloudwatch_log_group" "product_service_log_group" {
  name              = "${var.namespace}/ecs/${var.service_name}"
  retention_in_days = var.log_retention_in_days
}