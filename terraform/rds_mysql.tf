resource "aws_db_instance" "product_service_db" {
  db_name                = "product_service_db"
  engine                 = "mysql"
  engine_version         = "8.0.35"
  allocated_storage      = 20
  storage_type           = "gp2"
  identifier             = "product-service-db"
  username               = "admin"
  password               = "sashk4!admin?"
  publicly_accessible    = true
  port                   = 3306
  skip_final_snapshot    = true
  instance_class         = "db.t2.micro"
  vpc_security_group_ids = [aws_security_group.product_service.id]

  tags = {
    Name = "product_service_db"
  }
}

data "aws_iam_policy_document" "rds_describe_policy" {
  statement {
    actions   = ["rds:DescribeDBInstances"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "allow_rds_describe" {
  name        = "allow_rds_describe"
  description = "Allow EC2 instances to describe RDS instances"
  policy      = data.aws_iam_policy_document.rds_describe_policy.json
}

resource "aws_iam_role_policy_attachment" "attach_rds_describe" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.allow_rds_describe.arn
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
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.rds_policy.arn
}


resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Security group for RDS instance"
  vpc_id      = aws_vpc.main.id

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
    Name = "rds-security-group"
  }
}
