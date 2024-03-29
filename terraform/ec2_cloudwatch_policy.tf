resource "aws_iam_policy" "cloudwatch_policy" {
  name = var.cloudwatch_policy_name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ],
        Effect   = "Allow",
        Resource = "arn:aws:logs:*:*:*"
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "attach_cloudwatch_to_ec2" {
  role       = aws_iam_role.product_service_role.name
  policy_arn = aws_iam_policy.cloudwatch_policy.arn
}
