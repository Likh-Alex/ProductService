resource "aws_iam_policy" "api_gateway_policy" {
  name = "api_gateway_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : "apigateway:GET",
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "api_gateway_policy_attachment" {
  role       = aws_iam_role.product_service_role.name
  policy_arn = aws_iam_policy.api_gateway_policy.arn
}
