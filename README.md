# Hobby terraform modules
Some simple terraform modules useful for building infrastructure out for hobby projects

# Descriptions
- vpc: Creates a new VPC with public and private subnets as well as an internet gateway and NAT gateway so both public and private subnets have internet access
- public_ecr_repo: Creates a public ECR repository for images
- ecs_fargate_cluster: Creates an ECS cluster with a default fargate capacity provider
- simple_task_definition: Creates a task definition for a single container task
- ecs_service_with_public_alb: Deploys an ECS service to the VPCs public subnet with target group and ALB so it is available on the web
- simple_dynamo_table: Creates a dynamo table with a single indexed attribute used as the hash key
