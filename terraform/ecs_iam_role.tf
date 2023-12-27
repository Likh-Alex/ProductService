resource "aws_iam_role" "ecs_service_role" {
  name = "ecs-service-role"

  assume_role_policy = data.aws_iam_policy_document.ecs_service_role.json
}

data "aws_iam_policy_document" "ecs_service_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "ecs_service_role_policy" {
  name   = "ecs-service-role-policy"
  role   = aws_iam_role.ecs_service_role.id
  policy = data.aws_iam_policy_document.ecs_service_role_policy.json
}

data "aws_iam_policy_document" "ecs_service_role_policy" {
  statement {
    actions = [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:Describe*",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:RegisterTargets",
      "ec2:DescribeTags",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogStreams",
      "logs:PutSubscriptionFilter",
      "logs:PutLogEvents"
    ]

    resources = ["*"]
  }
}
