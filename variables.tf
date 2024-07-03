variable "ecs_family" {}
variable "ecs_execution_role_arn" {}
variable "ecs_task_name" {}
variable "ecs_task_image" {}
variable "ecs_service_name" {}
variable "ecs_cluster_id" {}
variable "ecs_capacity_provider" {}

variable "task_cpu" {}
variable "task_memory" {}
variable "task_execution_role_arn" {}
variable "task_role_arn" {}

variable "ecs_task_cpu" {}
variable "ecs_task_memory" {}
variable "ecs_task_port" {}

variable "service_name" {}
variable "service_desired_count" {}

variable "vpc_subnets" {
}
variable "vpc_security_group_ids" {
}

variable "aws_lb_target_group" {}
