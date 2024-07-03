variable "ecs_task_name" {}
variable "ecs_task_image" {}
variable "ecs_service_name" {}
variable "ecs_cluster_id" {}
variable "ecs_capacity_provider" {}

variable "task_cpu" {
    default     = 256
}
variable "task_memory" {
    default     = 512
}
variable "task_execution_role_arn" {}
variable "task_role_arn" {}

variable "ecs_task_cpu" {
    default     = 128
}
variable "ecs_task_memory" {
     default     = 256
}
variable "ecs_task_port" {}

variable "service_desired_count" {}

variable "vpc_subnets" {
}
variable "vpc_security_group_ids" {
}

variable "aws_lb_target_group" {}
