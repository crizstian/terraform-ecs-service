# Define the ECS task definition for the service
resource "aws_ecs_task_definition" "ecs_task_definition" {
  family             = var.ecs_task_name
  network_mode       = "bridge"
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = var.task_execution_role_arn
  task_role_arn            = var.task_role_arn
  requires_compatibilities = ["FARGATE"]
  # runtime_platform {
  #   operating_system_family = "LINUX"
  #   cpu_architecture        = "X86_64"
  # }

  container_definitions = jsonencode([{
      name      = var.ecs_task_name
      image     = var.ecs_task_image
      cpu       = var.ecs_task_cpu
      memory    = var.ecs_task_memory
      essential = true
    
      portMappings = [{
          containerPort = tonumber(var.ecs_task_port)
          hostPort      = tonumber(var.ecs_task_port)
          protocol      = "tcp"
    }]

    environment = [{
      name  = "PORT"
      value = tostring(var.ecs_task_port)
    }]
  }])
}

# Define the ECS service that will run the task
resource "aws_ecs_service" "ecs_service" {
  name            = var.ecs_service_name
  cluster         = var.ecs_cluster_id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = var.service_desired_count

  # network_configuration {
  #   subnets         = var.vpc_subnets
  #   security_groups = var.vpc_security_group_ids
  # }

  # force_new_deployment = true
  # placement_constraints {
  #   type = "distinctInstance"
  # }

  # triggers = {
  #   redeployment = plantimestamp()
  # }

  # capacity_provider_strategy {
  #   capacity_provider = var.ecs_capacity_provider
  #   weight            = 100
  # }

  load_balancer {
    target_group_arn = lookup(var.aws_lb_target_group, "ex-target", {}).arn
    container_name   = var.ecs_task_name
    container_port   = var.ecs_task_port
  }
}

resource "harness_platform_service" "example" {
  identifier  = "ecs"
  name        = var.ecs_service_name
  description = "test"
  org_id      = "cristian_labs_MQTH"
  project_id  = "infrastructure_team_MQTH"

  ## SERVICE V2 UPDATE
  ## We now take in a YAML that can define the service definition for a given Service
  ## It isn't mandatory for Service creation 
  ## It is mandatory for Service use in a pipeline

  yaml = <<-EOT
    service:
      name: ${var.ecs_service_name}
      identifier: ecs
      orgIdentifier: cristian_labs_MQTH
      projectIdentifier: infrastructure_team_MQTH
      serviceDefinition:
        spec:
        variables:
          - name: desiredCount
            type: String
            description: ""
            required: false
            value: "${var.service_desired_count}"
          manifests:
            - manifest:
                identifier: service
                type: EcsServiceDefinition
                spec:
                  store:
                    type: Harness
                    spec:
                      files:
                        - /ecs-service
          ecsTaskDefinitionArn: ${aws_ecs_task_definition.ecs_task_definition.arn}
        type: ECS
  EOT
}