variable "environment" {
  description = "environment name for the project (dev / prod)"
  type        = string
}

variable "application" {
  description = "name of the application"
  type        = string
}

variable "lambda_integrations" {
  description = "list of lambda integration configurations including HTTP method and URI"
  type        = list(any)
  /*
  example:
    {
      http_method = "PUT"
      http_path = "/users/{user_id}/preferences"
      function_arn = aws_lambda_function.lambda.arn
      function_name = aws_lambda_function.lambda.function_name
    }
  */
}
