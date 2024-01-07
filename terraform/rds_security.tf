data "aws_iam_policy_document" "rds_describe_policy" {
  statement {
    actions   = ["rds:DescribeDBInstances"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "allow_rds_describe_policy" {
  name        = "allow_rds_describe"
  description = "Allow EC2 instances to describe RDS instances"
  policy      = data.aws_iam_policy_document.rds_describe_policy.json
}

resource "aws_iam_role_policy_attachment" "attach_rds_describe" {
  role       = aws_iam_role.product_service_role.name
  policy_arn = aws_iam_policy.allow_rds_describe_policy.arn
}

resource "aws_iam_policy" "rds_policy" {
  name        = "RDSDescribeInstancesPolicy"
  description = "Allow EC2 instances to describe RDS instances"

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "rds:DescribeDBInstances",
        Resource = "*"
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "rds_policy_attachment" {
  role       = aws_iam_role.product_service_role.name
  policy_arn = aws_iam_policy.rds_policy.arn
}


resource "aws_security_group" "rds_sg" {
  name   = var.rds_sg_name
  vpc_id = aws_vpc.product_service_vpc.id

  # Allow inbound MySQL connections
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.rds_sg_name
  }
}