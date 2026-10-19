variable "name" {
  description = "Name prefix for security group resources."
  type        = string
  default     = "cloud-native-platform-dev"
}

variable "vpc_id" {
  description = "ID of the VPC where security groups will be created."
  type        = string
}

variable "alb_ingress_cidrs" {
  description = "IPv4 CIDR blocks permitted to access the ALB over HTTPS."
  type        = list(string)
  default     = ["0.0.0.0/0"]

  validation {
    condition     = length(var.alb_ingress_cidrs) > 0
    error_message = "Provide at least one approved client CIDR."
  }
}

variable "application_port" {
  description = "TCP port used by the application behind the ALB."
  type        = number
  default     = 8080

  validation {
    condition     = var.application_port >= 1 && var.application_port <= 65535
    error_message = "application_port must be between 1 and 65535."
  }
}

variable "postgres_port" {
  description = "TCP port used by PostgreSQL."
  type        = number
  default     = 5432
}

variable "redis_port" {
  description = "TCP port used by Redis."
  type        = number
  default     = 6379
}

variable "tags" {
  description = "Tags applied to all security group resources."
  type        = map(string)
  default     = {}
}