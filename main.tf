# Define the ECS task definition for the service
resource "aws_ecs_task_definition" "ecs_task_definition" {
  family             = var.ecs_task_name
  network_mode       = "awsvpc"
  execution_role_arn = var.ecs_execution_role_arn
  cpu                = 256
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  container_definitions = jsonencode([
    {
      name      = var.ecs_task_name
      image     = var.ecs_task_image
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
    }
  ])
}

# Define the ECS service that will run the task
resource "aws_ecs_service" "ecs_service" {
  name            = var.ecs_task_name
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = 2

  network_configuration {
    subnets         = var.vpc_subnets
    security_groups = var.vpc_security_group_ids
  }

  force_new_deployment = true
  placement_constraints {
    type = "distinctInstance"
  }

  triggers = {
    redeployment = plantimestamp()
  }

  capacity_provider_strategy {
    capacity_provider = var.ecs_capacity_provider
    weight            = 100
  }

  load_balancer {
    target_group_arn = var.aws_lb_target_group
    container_name   = var.ecs_task_name
    container_port   = 80
  }
}
