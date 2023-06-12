output "api_gateway_api_endpoint" {
  value = aws_apigatewayv2_api.api_gateway.api_endpoint
}

output "api_gateway_execution_arn" {
  value = aws_apigatewayv2_api.api_gateway.execution_arn
}
