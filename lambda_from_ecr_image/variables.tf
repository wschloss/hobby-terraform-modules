variable "environment" {
  description = "environment name for the project (dev / prod)"
  type        = string
}

variable "function_name" {
  description = "name of the lambda function"
  type        = string
}

variable "ecr_image_uri" {
  description = "URI of the ecr image for the lambda"
  type        = string
}

variable "image_command" {
  description = "command to pass to the image entry point"
  type        = list(string)
  // ["start", "dev"]
}

variable "function_environment_vars" {
  description = "ENV vars for the function"
  type        = map(any)
}

variable "lambda_role_policy_arn" {
  description = "IAM policy arn to attach to this lambda role"
}
