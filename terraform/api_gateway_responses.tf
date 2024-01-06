resource "aws_api_gateway_method_response" "products_post_200" {
  rest_api_id = aws_api_gateway_rest_api.product_service_api.id
  resource_id = aws_api_gateway_resource.products_resource.id
  http_method = aws_api_gateway_method.products_post.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  depends_on = [
    aws_api_gateway_method.products_post,
    aws_api_gateway_integration.products_post_integration
  ]
}

resource "aws_api_gateway_method_response" "products_get_200" {
  rest_api_id = aws_api_gateway_rest_api.product_service_api.id
  resource_id = aws_api_gateway_resource.products_resource.id
  http_method = aws_api_gateway_method.products_get.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  depends_on = [
    aws_api_gateway_method.products_get,
    aws_api_gateway_integration.products_get_integration
  ]
}