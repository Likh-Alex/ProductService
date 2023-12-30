# Retrieve the most recent AMI for ECS Optimized Amazon Linux 2
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "owner_alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

# Template for all instances that will be launched in the ECS cluster
resource "aws_launch_template" "ecs_cluster_launch_template" {
  name_prefix            = "${var.namespace}-ecs-cluster"
  image_id               = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.ssh_key.key_name
  user_data              = base64encode(data.template_file.user_data.rendered)
  vpc_security_group_ids = [aws_security_group.ec2.id]

  iam_instance_profile {
    arn = aws_iam_instance_profile.ecs_instance_profile.arn
  }

}

data "template_file" "user_data" {
  template = file("${path.module}/user_data.sh")
  vars = {
    cluster_name = aws_ecs_cluster.product_service_cluster.name
  }
}