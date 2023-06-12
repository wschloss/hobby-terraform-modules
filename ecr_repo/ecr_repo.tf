terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.1"
    }
  }
}

resource "aws_ecr_repository" "ecr_repo" {
  name = var.repository_name

  tags = {
    project = terraform.workspace
  }
}
