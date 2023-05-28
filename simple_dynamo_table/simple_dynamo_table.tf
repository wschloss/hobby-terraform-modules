terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.1"
    }
  }
}

resource "aws_dynamodb_table" "table" {
  name         = "${var.table_name}_${var.environment}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = var.hash_key_attribute["name"]

  attribute {
    name = var.hash_key_attribute["name"]
    type = var.hash_key_attribute["type"]
  }

  tags = {
    project = terraform.workspace
    environment = var.environment
  }
}
