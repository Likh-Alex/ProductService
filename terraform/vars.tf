########################################################################################################################
## Service variables
########################################################################################################################

variable "namespace" {
  description = "Namespace for resource names"
  default     = "product-service"
  type        = string
}

variable "service_name" {
  description = "A Docker image-compatible name for the service"
  type        = string
  default     = "cqrs-product-service"
}


variable "environment" {
  description = "Environment for the service"
  default     = "dev"
  type        = string
}

variable "domain_name" {
  description = "Domain name of the service (like service.example.com)"
  type        = string
  default     = "cqrs-product-service.com"
}

variable "region" {
  description = "AWS region"
  default     = "eu-central-1"
  type        = string
}

########################################################################################################################
## Network variables
########################################################################################################################

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC network"
  default     = "10.1.0.0/16"
  type        = string
}

variable "availability_zone_count" {
  description = "Describes how many availability zones are used"
  default     = 2
  type        = number
}

########################################################################################################################
## EC2 Computing variables
########################################################################################################################

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
  type        = string
}

########################################################################################################################
## ECS variables
########################################################################################################################

variable "ecs_task_deployment_minimum_healthy_percent" {
  description = "How many percent of a service must be running to still execute a safe deployment"
  default     = 50
  type        = number
}

variable "ecs_task_deployment_maximum_percent" {
  description = "How many additional tasks are allowed to run (in percent) while a deployment is executed"
  default     = 100
  type        = number
}

variable "cpu_units" {
  description = "Amount of CPU units for a single ECS task"
  default     = 100
  type        = number
}

variable "memory" {
  description = "Amount of memory in MB for a single ECS task"
  default     = 100
  type        = number
}


variable "ecs_task_min_count" {
  description = "How many ECS tasks should minimally run in parallel"
  default     = 2
  type        = number
}

variable "ecs_task_max_count" {
  description = "How many ECS tasks should maximally run in parallel"
  default     = 10
  type        = number
}

variable "ecs_memory_target_tracking" {
  description = "How many percent of memory should be used for the ECS service"
  default     = 50
  type        = number
}

variable "custom_origin_host_header" {
  description = "Custom header to ensure communication only through CloudFront"
  default     = "product_service_origin"
  type        = string
}

########################################################################################################################
## Cloudwatch
########################################################################################################################

variable "log_retention_in_days" {
  description = "Retention period for Cloudwatch logs"
  default     = 3
  type        = number
}

########################################################################################################################
## Capacity provider
########################################################################################################################

variable "max_scaling_step_size" {
  description = "Maximum number of tasks that can be started or stopped in one scaling action"
  default     = 3
  type        = number
}

variable "min_scaling_step_size" {
  description = "Minimum number of tasks that can be started or stopped in one scaling action"
  default     = 1
  type        = number
}

variable "target_capacity" {
  description = "Target capacity for the capacity provider"
  default     = 100
  type        = number
}

########################################################################################################################
## ASG
########################################################################################################################

variable "autoscaling_max_size" {
  description = "Max size of the autoscaling group"
  default     = 6
  type        = number
}

variable "autoscaling_min_size" {
  description = "Min size of the autoscaling group"
  default     = 2
  type        = number
}