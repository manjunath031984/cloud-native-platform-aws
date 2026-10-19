# ---------------------------------------------------------
# General Configuration
# ---------------------------------------------------------

variable "name" {
  description = "Name of the Application Load Balancer."
  type        = string

  validation {
    condition     = length(var.name) >= 2 && length(var.name) <= 32
    error_message = "The ALB name must contain between 2 and 32 characters."
  }
}

variable "tags" {
  description = "Tags applied to ALB resources."
  type        = map(string)
  default     = {}
}

# ---------------------------------------------------------
# Networking
# ---------------------------------------------------------

variable "vpc_id" {
  description = "ID of the existing VPC."
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for the internet-facing ALB. Use subnets in at least two Availability Zones."
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_ids) >= 2
    error_message = "The ALB requires at least two public subnets in different Availability Zones."
  }
}

variable "security_group_id" {
  description = "ID of the existing ALB security group."
  type        = string
}

# ---------------------------------------------------------
# Load Balancer Settings
# ---------------------------------------------------------

variable "enable_deletion_protection" {
  description = "Whether to enable deletion protection for the ALB."
  type        = bool
  default     = false
}

# ---------------------------------------------------------
# Target Group Settings
# ---------------------------------------------------------

variable "target_port" {
  description = "Port used by application targets."
  type        = number
  default     = 8080

  validation {
    condition     = var.target_port >= 1 && var.target_port <= 65535
    error_message = "The target port must be between 1 and 65535."
  }
}

variable "health_check_path" {
  description = "HTTP path used to check target health."
  type        = string
  default     = "/"

  validation {
    condition     = startswith(var.health_check_path, "/")
    error_message = "The health check path must start with '/'."
  }
}

variable "health_check_matcher" {
  description = "HTTP status codes accepted as healthy."
  type        = string
  default     = "200"
}

variable "deregistration_delay" {
  description = "Seconds the ALB waits before deregistering a target."
  type        = number
  default     = 30

  validation {
    condition     = var.deregistration_delay >= 0 && var.deregistration_delay <= 3600
    error_message = "The deregistration delay must be between 0 and 3600 seconds."
  }
}