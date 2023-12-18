resource "aws_api_gateway_rest_api" "my_api" {
  name        = "ProductServiceAPI"
  description = "API for Product Service"
}

resource "aws_api_gateway_resource" "products_resource" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id   = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part   = "products"
}

resource "aws_api_gateway_method" "products_get" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.products_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "products_post" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.products_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "products_get_integration" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.products_resource.id
  http_method = "GET"  # Directly specify the method
  type        = "HTTP"
  uri         = "http://${aws_instance.product_service.public_ip}/products"
  depends_on  = [aws_api_gateway_method.products_get]
}

resource "aws_api_gateway_integration" "products_post_integration" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.products_resource.id
  http_method = "POST"  # Directly specify the method
  type        = "HTTP"
  uri         = "http://${aws_instance.product_service.public_ip}/products"
  depends_on  = [aws_api_gateway_method.products_post]
}

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  stage_name  = "prod"
  depends_on  = [
    aws_api_gateway_integration.products_get_integration,
    aws_api_gateway_integration.products_post_integration
  ]
}
