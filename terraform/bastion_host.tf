resource "aws_security_group" "bastion_host_security_group" {
  name        = "${var.namespace}-bastion-host-sg-${var.environment}"
  description = "Security group for bastion host"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastion_host_instance" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public[0].id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ssh_key.id
  vpc_security_group_ids      = [aws_security_group.bastion_host_security_group.id]

  tags = {
    Name = "${var.namespace}-ec2-bastion-host-${var.environment}"
  }
}