variable "service_name" {
  description = "name of the service"
  type        = string
}

variable "environment" {
  description = "The environment name for this service (dev / prod)"
  type        = string
}

variable "service_port" {
  description = "port the service target group should listen on"
  type        = number
}

variable "container_port" {
  description = "container port to forward calls to"
  type        = number
}

variable "ecs_cluster_arn" {
  description = "ecs cluster to deploy to"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC to deploy into"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of IDs for the subnets to use with the alb"
  type        = list(string)
}

variable "task_definition_arn" {
  description = "task definition to deploy"
  type        = string
}

variable "desired_count" {
  description = "number of replicas"
  type        = number
}