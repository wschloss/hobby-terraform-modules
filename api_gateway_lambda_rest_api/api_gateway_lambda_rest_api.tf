terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.1"
    }
  }
}

resource "aws_apigatewayv2_api" "api_gateway" {
  name          = "${var.application}-api-${var.environment}"
  protocol_type = "HTTP"

  tags = {
    project     = terraform.workspace
    environment = var.environment
  }
}

resource "aws_apigatewayv2_integration" "lambda_integrations" {
  count = length(var.lambda_integrations)

  api_id           = aws_apigatewayv2_api.api_gateway.id
  integration_type = "AWS_PROXY"
  connection_type  = "INTERNET"

  description     = "${var.lambda_integrations[count.index].function_name}-integration"
  integration_uri = var.lambda_integrations[count.index].function_arn
}

resource "aws_apigatewayv2_route" "lambda_routes" {
  count = length(var.lambda_integrations)

  api_id    = aws_apigatewayv2_api.api_gateway.id
  route_key = "${var.lambda_integrations[count.index].http_method} ${var.lambda_integrations[count.index].http_path}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integrations[count.index].id}"
}

resource "aws_lambda_permission" "lambda_execute_permissions" {
  count = length(var.lambda_integrations)

  statement_id  = "AllowInvoke_${var.lambda_integrations[count.index].function_name}"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_integrations[count.index].function_name
  principal     = "apigateway.amazonaws.com"

  # The /* part allows invocation from any stage, method and resource path
  # within API Gateway.
  source_arn = "${aws_apigatewayv2_api.api_gateway.execution_arn}/*"
}

resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.api_gateway.id
  name        = "$default"
  auto_deploy = true
}
