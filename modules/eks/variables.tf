# =========================================================
# EKS Cluster Variables
# =========================================================

variable "cluster_name" {
  description = "Name of the Amazon EKS cluster."
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster."
  type        = string
}

# =========================================================
# VPC Integration
# =========================================================

variable "vpc_id" {
  description = "ID of the VPC used by the EKS cluster."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs used by EKS and managed node groups."
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_ids) >= 2
    error_message = "At least two private subnets are required."
  }
}

# =========================================================
# EKS API Endpoint Access
# =========================================================

variable "endpoint_private_access" {
  description = "Enable private access to the Kubernetes API endpoint."
  type        = bool
  default     = true
}

variable "endpoint_public_access" {
  description = "Enable public access to the Kubernetes API endpoint."
  type        = bool
  default     = true
}

variable "endpoint_public_access_cidrs" {
  description = "IPv4 CIDRs allowed to access the public Kubernetes API endpoint."
  type        = list(string)

  default = ["203.0.113.10/32"]

  validation {
    condition     = length(var.endpoint_public_access_cidrs) > 0
    error_message = "Provide at least one CIDR when public endpoint access is enabled."
  }
}

# =========================================================
# Application + Redis Node Group
# =========================================================

variable "app_redis_instance_types" {
  description = "EC2 instance types for the application and Redis node group."
  type        = list(string)
  default     = ["c7i-flex.large"]
}

variable "app_redis_node_desired_size" {
  description = "Desired number of application and Redis worker nodes."
  type        = number
  default     = 1
}

variable "app_redis_node_min_size" {
  description = "Minimum number of application and Redis worker nodes."
  type        = number
  default     = 1
}

variable "app_redis_node_max_size" {
  description = "Maximum number of application and Redis worker nodes."
  type        = number
  default     = 1
}

# =========================================================
# PostgreSQL Node Group
# =========================================================

variable "postgres_instance_types" {
  description = "EC2 instance types for the PostgreSQL node group."
  type        = list(string)
  default     = ["m7i-flex.large"]
}

variable "postgres_node_desired_size" {
  description = "Desired number of PostgreSQL worker nodes."
  type        = number
  default     = 1
}

variable "postgres_node_min_size" {
  description = "Minimum number of PostgreSQL worker nodes."
  type        = number
  default     = 1
}

variable "postgres_node_max_size" {
  description = "Maximum number of PostgreSQL worker nodes."
  type        = number
  default     = 1
}

# =========================================================
# Shared Node Group Configuration
# =========================================================

variable "node_capacity_type" {
  description = "Capacity type used by both managed node groups."
  type        = string
  default     = "ON_DEMAND"

  validation {
    condition     = contains(["ON_DEMAND", "SPOT"], var.node_capacity_type)
    error_message = "node_capacity_type must be ON_DEMAND or SPOT."
  }
}

variable "node_disk_size" {
  description = "Root disk size for each worker node in GiB."
  type        = number
  default     = 10

  validation {
    condition     = var.node_disk_size >= 5
    error_message = "Worker node disk size must be at least 20 GiB."
  }
}

variable "log_retention_days" {
  description = "Retention period for EKS control-plane logs in days."
  type        = number
  default     = 7
}

# =========================================================
# Resource Tags
# =========================================================

variable "tags" {
  description = "Tags applied to EKS resources."
  type        = map(string)
  default     = {}
}