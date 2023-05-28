terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.1"
    }
  }
}

resource "aws_iam_role" "task_role" {
  name               = "${var.application}-task-role"
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": "ECSPrincipal"
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "task_role_policy" {
  role       = aws_iam_role.task_role.name
  policy_arn = var.task_role_policy_arn
}

resource "aws_ecs_task_definition" "task_definition" {
  family                   = var.application
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  container_definitions = jsonencode([
    {
      name      = var.application
      image     = var.image
      cpu       = var.resource_requirements["cpu"]
      memory    = var.resource_requirements["mem"]
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
        }
      ]
      environment = var.application_environment
    }
  ])

  task_role_arn = aws_iam_role.task_role.arn

  tags = {
    project = terraform.workspace
  }
}
