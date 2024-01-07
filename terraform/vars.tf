# API Gateway variables
variable "api_name" {
  default = "ProductServiceAPI"
  type    = string
}

variable "api_stage_name" {
  default = "prod"
  type    = string
}

variable "access_logs_settings_format" {
  default = {
    "requestId"      = "$context.requestId",
    "ip"             = "$context.identity.sourceIp",
    "caller"         = "$context.identity.caller",
    "user"           = "$context.identity.user",
    "requestTime"    = "$context.requestTime",
    "httpMethod"     = "$context.httpMethod",
    "resourcePath"   = "$context.resourcePath",
    "status"         = "$context.status",
    "protocol"       = "$context.protocol",
    "responseLength" = "$context.responseLength"
  }
  type = map(string)
}

variable "api_gateway_log_group_name" {
  default = "API_Gateway_Execution_Logs"
  type    = string
}

variable "api_gateway_log_retention_in_days" {
  default = 7
  type    = number
}

# EC2 variables
variable "ec2_ami_id" {
  default = "ami-024f768332f080c5e"
  type    = string
}

variable "ec2_instance_type" {
  default = "t2.small"
  type    = string
}

variable "ec2_instance_name" {
  default = "product_service_instance"
  type    = string
}

variable "ssh_key_name" {
  default = "product_service_key"
  type    = string
}

variable "product_service_role_name" {
  default = "product_service_role"
  type    = string
}

variable "product_service_port" {
  default = 9091
  type    = number
}

variable "security_group_name" {
  default = "product_service_security_group"
  type    = string
}

# CloudWatch variables
variable "cloudwatch_policy_name" {
  default = "Cloud_Watch_Logs_Policy"
  type    = string
}

# VPC variables
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC network"
  default     = "10.1.0.0/16"
  type        = string
}
variable "vpc_name" {
  default = "Product service VPC"
}

# RDS variables
variable "db_name" {
  default = "product_service_db"
  type    = string
}
variable "db_engine" {
  default = "mysql"
  type    = string
}
variable "db_engine_version" {
  default = "8.0.35"
  type    = string
}
variable "db_allocated_storage" {
  default = 20
  type    = number
}
variable "db_storage_type" {
  default = "gp2"
  type    = string
}
variable "db_identifier" {
  default = "product-service"
  type    = string
}
variable "db_publicly_accessible" {
  default = true
}
variable "db_port" {
  default = 3306
  type    = number
}
variable "db_skip_final_snapshot" {
  default = true
}
variable "db_instance_class" {
  default = "db.t2.micro"
  type    = string
}
variable "rds_sg_name" {
  default = "rds-security-group"
  type    = string
}

# Credentials variables
variable "aws_rds_db_username" {
  description = "Database administrator username"
  type        = string
  sensitive   = true
}

variable "aws_rds_db_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
}