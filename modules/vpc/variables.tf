variable "name" {
  description = "Name prefix for VPC resources."
  type        = string
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr must be a valid IPv4 CIDR block."
  }
}

variable "availability_zones" {
  description = "Exactly two Availability Zones in the configured AWS region."
  type        = list(string)
  validation {
    condition     = length(var.availability_zones) == 2 && length(distinct(var.availability_zones)) == 2
    error_message = "Provide exactly two distinct Availability Zones."
  }
}

variable "public_subnet_cidrs" {
  description = "Two public subnet CIDRs, one per Availability Zone."
  type        = list(string)
  default     = ["10.0.0.0/20", "10.0.16.0/20"]
  validation {
    condition     = length(var.public_subnet_cidrs) == 2
    error_message = "Provide exactly two public subnet CIDRs."
  }
}

variable "private_subnet_cidrs" {
  description = "Two private subnet CIDRs, one per Availability Zone."
  type        = list(string)
  default     = ["10.0.32.0/20", "10.0.48.0/20"]
  validation {
    condition     = length(var.private_subnet_cidrs) == 2
    error_message = "Provide exactly two private subnet CIDRs."
  }
}

variable "nat_gateway_mode" {
  description = "NAT topology: single for lower cost, per_az for one NAT per AZ."
  type        = string
  default     = "single"
  validation {
    condition     = contains(["single", "per_az"], var.nat_gateway_mode)
    error_message = "nat_gateway_mode must be single or per_az."
  }
}

variable "enable_nat_gateway" {
  description = "Whether to create NAT Gateways. If false, private subnets have no default internet route."
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Enable DNS resolution in the VPC."
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC."
  type        = bool
  default     = true
}

variable "enable_s3_gateway_endpoint" {
  description = "Create an S3 gateway endpoint associated with private route tables."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags applied to supported resources."
  type        = map(string)
  default     = {}
}
