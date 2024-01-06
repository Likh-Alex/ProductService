variable "log_retention_in_days" {
  description = "Retention period for Cloudwatch logs"
  default     = 3
  type        = number
}

variable "api_name" {
  description = "Name of the API"
  default     = "ProductServiceAPI"
  type        = string
}

variable "api_stage_name" {
  description = "Name of the API stage"
  default     = "prod"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC network"
  default     = "10.1.0.0/16"
  type        = string
}
