terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.1"
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "${var.function_name}-role-${var.environment}"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "lambda.amazonaws.com"
          },
          "Effect" : "Allow",
        }
      ]
    }
  )
  tags = {
    project     = terraform.workspace
    environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "lambda_role_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = var.lambda_role_policy_arn
}

resource "aws_lambda_function" "lambda" {
  function_name = "${var.function_name}-${var.environment}"
  image_uri     = var.ecr_image_uri
  package_type  = "Image"
  role          = aws_iam_role.lambda_role.arn
  image_config {
    command = var.image_command
  }
  environment {
    variables = var.function_environment_vars
  }
  tags = {
    project     = terraform.workspace
    environment = var.environment
  }
}
