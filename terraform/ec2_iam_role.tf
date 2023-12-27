# Roles for EC2 instances
resource "aws_iam_role" "ec2_instance_launch_role" {
  name               = "ec2_instance_launch_role"
  assume_role_policy = data.aws_iam_policy_document.ec2_instance_launch_role_policy.json
}

resource "aws_iam_role_policy_attachment" "ec2_instance_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  role       = aws_iam_role.ec2_instance_launch_role.name
}

resource "aws_iam_instance_profile" "ec2_instance_launch_role" {
  name = "ec2_instance_launch_role"
  role = aws_iam_role.ec2_instance_launch_role.name
}

data "aws_iam_policy_document" "ec2_instance_launch_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com",
        "ecs.amazonaws.com"
      ]
    }
  }
}