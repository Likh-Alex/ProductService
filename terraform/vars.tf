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


## Network variables

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC network"
  default     = "10.1.0.0/16"
  type        = string
}

variable "availability_zone_count" {
  description = "Describes how many availability zones are used"
  default     = 1
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

########################################################################################################################
## Cloudwatch
########################################################################################################################

variable "log_retention_in_days" {
  description = "Retention period for Cloudwatch logs"
  default     = 3
  type        = number
}