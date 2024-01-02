resource "aws_api_gateway_rest_api" "product_service_api" {
  name        = "ProductServiceAPI"
  description = "API for Product Service"
}

resource "aws_api_gateway_resource" "products_resource" {
  parent_id   = aws_api_gateway_rest_api.product_service_api.root_resource_id
  path_part   = "products"
  rest_api_id = aws_api_gateway_rest_api.product_service_api.id
}

resource "aws_api_gateway_method" "products_post" {
  rest_api_id   = aws_api_gateway_rest_api.product_service_api.id
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.products_resource.id
  authorization = "NONE"
}

resource "aws_api_gateway_method_settings" "products_post_settings" {
  rest_api_id = aws_api_gateway_rest_api.product_service_api.id
  stage_name  = "prod"

  method_path = "*/*"
  settings {
    logging_level      = "INFO"
    metrics_enabled    = true
    data_trace_enabled = false
  }
}

resource "aws_api_gateway_integration" "products_post_integration" {
  rest_api_id             = aws_api_gateway_rest_api.product_service_api.id
  resource_id             = aws_api_gateway_resource.products_resource.id
  http_method             = aws_api_gateway_method.products_post.http_method
  type                    = "HTTP"
  uri                     = "http://${aws_instance.product_service.public_ip}/products"
  depends_on              = [aws_api_gateway_method.products_post]
  integration_http_method = "POST"
}

resource "aws_api_gateway_method" "products_get" {
  rest_api_id   = aws_api_gateway_rest_api.product_service_api.id
  resource_id   = aws_api_gateway_resource.products_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "products_get_integration" {
  rest_api_id             = aws_api_gateway_rest_api.product_service_api.id
  resource_id             = aws_api_gateway_resource.products_resource.id
  http_method             = aws_api_gateway_method.products_get.http_method
  type                    = "HTTP"
  uri                     = "http://${aws_instance.product_service.public_ip}/products"
  depends_on              = [aws_api_gateway_method.products_get]
  integration_http_method = "GET"
}

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.product_service_api.id
  stage_name  = "prod"
  depends_on  = [
    aws_api_gateway_integration.products_get_integration,
    aws_api_gateway_method.products_get,
    aws_api_gateway_integration.products_post_integration,
    aws_api_gateway_method.products_post,
    aws_api_gateway_integration_response.products_post_integration_response,
    aws_api_gateway_integration_response.products_get_integration_response,
    aws_api_gateway_method_response.products_post_200,
    aws_api_gateway_method_response.products_get_200
  ]
}

resource "aws_api_gateway_integration_response" "products_post_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.product_service_api.id
  resource_id = aws_api_gateway_resource.products_resource.id
  http_method = aws_api_gateway_method.products_post.http_method
  status_code = "200" # Default success response

  response_templates = {
    "application/json" = ""
  }
  depends_on = [
    aws_api_gateway_method.products_post,
    aws_api_gateway_integration.products_post_integration
  ]
}

resource "aws_api_gateway_integration_response" "products_get_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.product_service_api.id
  resource_id = aws_api_gateway_resource.products_resource.id
  http_method = aws_api_gateway_method.products_get.http_method
  status_code = "200" # Default success response

  response_templates = {
    "application/json" = ""
  }

  depends_on = [
    aws_api_gateway_method.products_get,
    aws_api_gateway_integration.products_get_integration
  ]
}


resource "aws_api_gateway_method_response" "products_post_200" {
  rest_api_id = aws_api_gateway_rest_api.product_service_api.id
  resource_id = aws_api_gateway_resource.products_resource.id
  http_method = aws_api_gateway_method.products_post.http_method
  status_code = "200" # Success response

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
  status_code = "200" # Success response

  response_models = {
    "application/json" = "Empty"
  }

  depends_on = [
    aws_api_gateway_method.products_get,
    aws_api_gateway_integration.products_get_integration
  ]
}






