resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
      },
    ],
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  role = aws_iam_role.ec2_role.name
}

resource "aws_instance" "product_service" {
  ami                    = "ami-024f768332f080c5e"
  instance_type          = "t2.small"
  key_name               = aws_key_pair.ssh_key.key_name
  vpc_security_group_ids = [aws_security_group.product_service.id]

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.id

  tags = {
    Name = "product_service_instance"
  }

  user_data = file("${path.module}/user_data.sh")

}

output "instance_ip" {
  description = "The public ip for ssh access"
  value       = aws_instance.product_service.public_ip
}

