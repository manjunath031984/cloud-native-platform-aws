# ============================================================
# Project Variables
# ============================================================

variable "name" {
  description = "Base name for cloud infrastructure resources."
  type        = string
  default     = "cloud-native-platform-dev"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Common tags applied to AWS resources."
  type        = map(string)

  default = {
    Project     = "cloud-native-platform-aws"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

# ============================================================
# VPC Variables
# ============================================================

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability Zones used by the VPC."
  type        = list(string)

  default = [
    "ap-southeast-2a",
    "ap-southeast-2b"
  ]

  validation {
    condition     = length(var.availability_zones) >= 2
    error_message = "At least two Availability Zones are required."
  }
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets."
  type        = list(string)

  default = [
    "10.0.0.0/20",
    "10.0.16.0/20"
  ]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets."
  type        = list(string)

  default = [
    "10.0.32.0/20",
    "10.0.48.0/20"
  ]
}

variable "enable_nat_gateway" {
  description = "Whether to create NAT Gateway resources."
  type        = bool
  default     = true
}

variable "nat_gateway_mode" {
  description = "NAT Gateway deployment mode: single or per_az."
  type        = string
  default     = "single"

  validation {
    condition     = contains(["single", "per_az"], var.nat_gateway_mode)
    error_message = "nat_gateway_mode must be single or per_az."
  }
}

variable "enable_s3_gateway_endpoint" {
  description = "Whether to create an S3 Gateway VPC endpoint."
  type        = bool
  default     = true
}

# ============================================================
# Security Groups Variables
# ============================================================

variable "alb_ingress_cidrs" {
  description = "IPv4 CIDRs allowed to access the public ALB."
  type        = list(string)
  default     = ["0.0.0.0/0"]

  validation {
    condition     = length(var.alb_ingress_cidrs) > 0
    error_message = "At least one ALB ingress CIDR must be provided."
  }
}

variable "application_port" {
  description = "TCP port used by the application."
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

  validation {
    condition     = var.postgres_port >= 1 && var.postgres_port <= 65535
    error_message = "postgres_port must be between 1 and 65535."
  }
}

variable "redis_port" {
  description = "TCP port used by Redis."
  type        = number
  default     = 6379

  validation {
    condition     = var.redis_port >= 1 && var.redis_port <= 65535
    error_message = "redis_port must be between 1 and 65535."
  }
}

# ============================================================
# Amazon EKS Cluster Variables
# ============================================================

variable "eks_cluster_name" {
  description = "Name of the Amazon EKS cluster."
  type        = string
  default     = "cloud-native-platform-dev"
}

variable "eks_kubernetes_version" {
  description = "Kubernetes version for the EKS cluster."
  type        = string
  default     = "1.36"
}

variable "eks_endpoint_public_access_cidrs" {
  description = "Trusted public IPv4 CIDRs allowed to access the EKS API endpoint."
  type        = list(string)

  # Replace with your actual trusted public IP CIDR in terraform.tfvars.
  default = ["203.0.113.10/32"]

  validation {
    condition     = length(var.eks_endpoint_public_access_cidrs) > 0
    error_message = "At least one trusted CIDR must be configured when public endpoint access is enabled."
  }
}

# ============================================================
# EKS Application + Redis Node Group Variables
# ============================================================

variable "app_redis_instance_types" {
  description = "EC2 instance types for the application and Redis node group."
  type        = list(string)
  default     = ["c7i-flex.large"]
}

variable "app_redis_node_desired_size" {
  description = "Desired node count for application and Redis."
  type        = number
  default     = 1
}

variable "app_redis_node_min_size" {
  description = "Minimum node count for application and Redis."
  type        = number
  default     = 1
}

variable "app_redis_node_max_size" {
  description = "Maximum node count for application and Redis."
  type        = number
  default     = 1
}

# ============================================================
# EKS PostgreSQL Node Group Variables
# ============================================================

variable "postgres_instance_types" {
  description = "EC2 instance types for the PostgreSQL node group."
  type        = list(string)
  default     = ["m7i-flex.large"]
}

variable "postgres_node_desired_size" {
  description = "Desired node count for PostgreSQL."
  type        = number
  default     = 1
}

variable "postgres_node_min_size" {
  description = "Minimum node count for PostgreSQL."
  type        = number
  default     = 1
}

variable "postgres_node_max_size" {
  description = "Maximum node count for PostgreSQL."
  type        = number
  default     = 1
}

# ============================================================
# Shared EKS Node Configuration
# ============================================================

variable "eks_node_capacity_type" {
  description = "Capacity type used by both EKS managed node groups."
  type        = string
  default     = "ON_DEMAND"

  validation {
    condition     = contains(["ON_DEMAND", "SPOT"], var.eks_node_capacity_type)
    error_message = "eks_node_capacity_type must be ON_DEMAND or SPOT."
  }
}

variable "eks_node_disk_size" {
  description = "Worker node root disk size in GiB."
  type        = number
  default     = 10

  validation {
    condition     = var.eks_node_disk_size >= 5
    error_message = "eks_node_disk_size must be at least 20 GiB."
  }
}

# ============================================================
# HashiCorp Vault Variables
# ============================================================

variable "vault_chart_version" {
  description = "Pinned HashiCorp Vault Helm chart version."
  type        = string
}

variable "vault_image_tag" {
  description = "Pinned HashiCorp Vault container image version."
  type        = string
}

# ============================================================
# Amazon ECR Variables
# ============================================================

variable "ecr_repository_names" {
  description = "Names of private ECR repositories for application container images."
  type        = set(string)

  default = [
    "cloud-native-platform-app"
  ]
}