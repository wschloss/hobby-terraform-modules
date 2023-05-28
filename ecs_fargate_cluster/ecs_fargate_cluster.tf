terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.1"
    }
  }
}

resource "aws_ecs_cluster" "cluster" {
  name = "${var.cluster_name}-${var.environment}"
  tags = {
    project     = terraform.workspace
    environment = var.environment
  }
}

resource "aws_ecs_cluster_capacity_providers" "fargate_capacity" {
  cluster_name = aws_ecs_cluster.cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}
