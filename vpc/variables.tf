variable "environment" {
  description = "Environment this VPC is for (dev / prod)"
  type        = string
}

variable "cidr_block" {
  description = "Full block of IPs for the vpc"
  type        = string
}

variable "public_subnets" {
  description = "cidr blocks for public subnets"
  type        = list(string)
}

variable "private_subnets" {
  description = "cidr blocks for private subnets"
  type        = list(string)
}

variable "region" {
  description = "region for the VPC"
  type        = string
}
