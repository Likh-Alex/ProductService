resource "aws_iam_instance_profile" "ec2_profile" {
  role = aws_iam_role.product_service_role.name
}

resource "aws_instance" "product_service" {
  ami                    = var.ec2_ami_id
  instance_type          = var.ec2_instance_type
  key_name               = aws_key_pair.ssh_key.key_name
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.id

  tags = {
    Name = var.ec2_instance_name
  }

  user_data = file("${path.module}/ec2_user_data.sh")

}

output "instance_ip" {
  description = "The public ip for ssh access"
  value       = aws_instance.product_service.public_ip
}

