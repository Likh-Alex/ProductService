variable "vpc_subnet_ids" {
  type    = list(string)
  default = ["subnet-062b6a1bd71a1b5d3", "subnet-0f17d186f752467b8", "subnet-0a9549d768aab5ad0"]
}

variable "vpc_id" {
  type    = string
  default = "vpc-0fc738c77bde1d207"
}

resource "aws_alb" "main" {
  name            = "main-load-balancer"
  subnets         = ["subnet-062b6a1bd71a1b5d3", "subnet-0f17d186f752467b8"]
  security_groups = [aws_security_group.alb_sg.id]
}

resource "aws_alb_target_group" "tg_axonserver" {
  name     = "tg-axonserver"
  port     = 8024
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_alb_target_group" "tg_product_service" {
  name     = "tg-product-service"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_alb_listener" "product_service_listener" {
  load_balancer_arn = aws_alb.main.arn
  port              = "80"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.tg_product_service.arn
  }
}

resource "aws_alb_listener" "axonserver_listener" {
  load_balancer_arn = aws_alb.main.arn
  port              = "8024"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.tg_axonserver.arn
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Security group for ALB in default VPC"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
