resource "aws_ecs_cluster" "product_service_cluster" {
  name = "product_service-cluster"
}

resource "aws_ecs_service" "product_service" {
  name            = "product_service"
  cluster         = aws_ecs_cluster.product_service_cluster.id
  task_definition = aws_ecs_task_definition.product_service.arn
  launch_type     = "EC2"
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_alb_target_group.tg_product_service.arn
    container_name   = "product_service"
    container_port   = 8081
  }
}

resource "aws_ecs_task_definition" "product_service" {
  family                   = "product_service"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  cpu                      = "256"
  memory                   = "205"

  container_definitions = jsonencode([
    {
      name         = "axonserver",
      image        = "axoniq/axonserver:latest",
      cpu          = 0,
      memory       = 100,
      portMappings = [
        {
          containerPort = 8024,
          hostPort      = 8024,
          protocol      = "tcp"
        },
        {
          containerPort = 8124,
          hostPort      = 8124,
          protocol      = "tcp"
        }
      ],
      essential        = true,
      logConfiguration = {
        logDriver = "awslogs",
        options   = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/product_service",
          "awslogs-region"        = "eu-central-1",
          "awslogs-stream-prefix" = "ecs"
        }
      }
    },
    {
      name         = "product_service",
      image        = "154479180857.dkr.ecr.eu-central-1.amazonaws.com/product_service_repo:latest",
      cpu          = 0,
      memory       = 100,
      portMappings = [
        {
          containerPort = 8081,
          hostPort      = 8081,
          protocol      = "tcp"
        }
      ],
      essential = true
    }
  ])
}


resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs_execution_role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
      },
    ],
  })
}

resource "aws_iam_role" "ecs_instance_role" {
  name = "ecs_instance_role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
      },
    ],
  })
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecs_instance_profile"
  role = aws_iam_role.ecs_instance_role.name
}

resource "aws_launch_configuration" "ecs_launch_configuration" {
  name_prefix     = "ecs-"
  image_id        = "ami-024f768332f080c5e"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.ecs_instances_sg.id]
  key_name        = aws_key_pair.ssh_key.key_name

  iam_instance_profile = aws_iam_instance_profile.ecs_instance_profile.name

  user_data = <<-EOF
                #!/bin/bash
                echo ECS_CLUSTER=${aws_ecs_cluster.product_service_cluster.name} >> /etc/ecs/ecs.config
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "ecs_instances_sg" {
  name        = "ecs-instances-sg"
  description = "Security group for ECS instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


