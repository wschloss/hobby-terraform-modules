variable "application" {
  description = "name of the app"
  type        = string
}

variable "image" {
  description = "ECR image to run"
  type        = string
}

variable "container_port" {
  description = "The port container listens on"
  type        = number
}

variable "application_environment" {
  description = "ENV for the application container"
  type        = list(any)
}

variable "resource_requirements" {
  description = "cpu and mem requirements for the container. Must be a valid fargate configuration"
  type        = map(any)
}

variable "task_role_policy_arn" {
  description = "ARN of policy to attach to task role and limit task permissions"
  type = string
}