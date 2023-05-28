terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.1"
    }
  }
}

locals {
  availability_zones = ["${var.region}a", "${var.region}b", "${var.region}c"]
}

resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block
  tags = {
    Name        = "${terraform.workspace}-vpc-${var.environment}"
    project     = terraform.workspace
    environment = var.environment
  }
}

resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnets)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.public_subnets, count.index)
  availability_zone = element(local.availability_zones, count.index)

  tags = {
    project     = terraform.workspace
    environment = var.environment
    tier        = "public"
  }
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(local.availability_zones, count.index)

  tags = {
    project     = terraform.workspace
    environment = var.environment
    tier        = "private"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    project     = terraform.workspace
    environment = var.environment
  }
}

resource "aws_route_table" "internet_gateway_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    project     = terraform.workspace
    environment = var.environment
  }
}

resource "aws_route_table_association" "public_subnet_internet_route" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.internet_gateway_route_table.id
}

resource "aws_eip" "nat_ip" {
  depends_on = [aws_internet_gateway.internet_gateway]

  domain = "vpc"
  tags = {
    project     = terraform.workspace
    environment = var.environment
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  depends_on    = [aws_internet_gateway.internet_gateway]
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.public_subnets[0].id
  tags = {
    project     = terraform.workspace
    environment = var.environment
  }
}

resource "aws_route_table" "nat_gateway_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    project     = terraform.workspace
    environment = var.environment
  }
}

resource "aws_route_table_association" "private_subnet_internet_route" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = aws_route_table.nat_gateway_route_table.id
}
