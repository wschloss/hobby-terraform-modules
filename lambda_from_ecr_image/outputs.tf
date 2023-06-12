output "function_arn" {
  value = aws_lambda_function.lambda.arn
}

output "function_name" {
  value = aws_lambda_function.lambda.function_name
}

output "function_role_arn" {
  value = aws_iam_role.lambda_role.arn
}
