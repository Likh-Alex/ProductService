resource "aws_api_gateway_integration" "products_post_integration" {
  rest_api_id             = aws_api_gateway_rest_api.product_service_api.id
  resource_id             = aws_api_gateway_resource.products_resource.id
  http_method             = aws_api_gateway_method.products_post.http_method
  type                    = "HTTP"
  uri                     = "http://${aws_instance.product_service.public_ip}:9091/products"
  depends_on              = [aws_api_gateway_method.products_post]
  integration_http_method = "POST"
}

resource "aws_api_gateway_integration" "products_get_integration" {
  rest_api_id             = aws_api_gateway_rest_api.product_service_api.id
  resource_id             = aws_api_gateway_resource.products_resource.id
  http_method             = aws_api_gateway_method.products_get.http_method
  type                    = "HTTP"
  uri                     = "http://${aws_instance.product_service.public_ip}:9091/products"
  depends_on              = [aws_api_gateway_method.products_get]
  integration_http_method = "GET"
}