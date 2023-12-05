variable "ecs_family" {}
variable "ecs_execution_role_arn" {}
variable "ecs_task_name" {}
variable "ecs_task_image" {}
variable "ecs_service_name" {}
variable "ecs_cluster_id" {}
variable "ecs_capacity_provider" {}

variable "vpc_subnets" {
  type = list(string)
}
variable "vpc_security_group_ids" {
  type = list(string)
}

variable "aws_lb_target_group" {}
