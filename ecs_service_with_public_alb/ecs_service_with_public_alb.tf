terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.1"
    }
  }
}

resource "aws_security_group" "alb_security_group" {
  vpc_id = var.vpc_id
  name   = "${var.service_name}-alb-sg-${var.environment}"

  ingress {
    from_port   = var.service_port
    to_port     = var.service_port
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
    project     = terraform.workspace
    environment = var.environment
  }
}

resource "aws_lb" "alb" {
  name               = "${var.service_name}-alb-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = [aws_security_group.alb_security_group.id]

  tags = {
    project     = terraform.workspace
    environment = var.environment
  }
}

resource "aws_lb_target_group" "target_group" {
  name        = "${var.service_name}-tg-${var.environment}"
  target_type = "ip"
  port        = var.service_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  tags = {
    project     = terraform.workspace
    environment = var.environment
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.service_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

resource "aws_security_group" "service_security_group" {
  vpc_id = var.vpc_id
  name   = "${var.service_name}-service-sg-${var.environment}"

  ingress {
    from_port       = var.container_port
    to_port         = var.container_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    project     = terraform.workspace
    environment = var.environment
  }
}

resource "aws_ecs_service" "service" {
  name            = "${var.service_name}-service-${var.environment}"
  cluster         = var.ecs_cluster_arn
  task_definition = var.task_definition_arn
  desired_count   = var.desired_count

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = var.service_name
    container_port   = var.container_port
  }

  network_configuration {
    subnets          = var.public_subnet_ids
    assign_public_ip = true
    security_groups  = [resource.aws_security_group.service_security_group.id]
  }

  // This prevents tf from wanting to recreate the service each time instead of modify in place
  // see https://github.com/hashicorp/terraform-provider-aws/issues/22823
  capacity_provider_strategy {
    base              = 1
    capacity_provider = "FARGATE"
    weight            = 100
  }

  tags = {
    project     = terraform.workspace
    environment = var.environment
  }

  depends_on = [aws_lb_listener.http_listener]
}
