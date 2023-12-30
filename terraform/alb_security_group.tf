# Security Group for ALB
resource "aws_security_group" "alb_security_group" {
  name        = "${var.namespace}-alb-sg-${var.environment}"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.main.id

  egress {
    description = "Allow all outbound traffic by default"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.namespace}-alb-sg-${var.environment}"
  }
}

data "aws_ec2_managed_prefix_list" "cloudfront" {
  name = "com.amazonaws.global.cloudfront.origin-facing"
}

# Allow HTTP traffic from CloudFront
resource "aws_security_group_rule" "alb_https_ingress" {
  security_group_id = aws_security_group.alb_security_group.id
  description       = "Allow HTTPS traffic from CloudFront"
  from_port         = 443
  protocol          = "tcp"
  prefix_list_ids   = [data.aws_ec2_managed_prefix_list.cloudfront.id]
  to_port           = 443
  type              = "ingress"
}