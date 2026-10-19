# ============================================================
# VPC Module
# ============================================================

module "vpc" {
  source = "./modules/vpc"

  name               = var.name
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones

  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

  # NAT Gateway Configuration
  enable_nat_gateway = var.enable_nat_gateway
  nat_gateway_mode   = var.nat_gateway_mode

  # S3 Gateway Endpoint
  enable_s3_gateway_endpoint = var.enable_s3_gateway_endpoint

  # Resource Tags
  tags = var.tags
}

# ============================================================
# Security Groups Module
# ============================================================

module "security_groups" {
  source = "./modules/security-groups"

  name   = var.name
  vpc_id = module.vpc.vpc_id

  # ALB Ingress Configuration
  alb_ingress_cidrs = var.alb_ingress_cidrs

  # Application and Data Ports
  application_port = var.application_port
  postgres_port    = var.postgres_port
  redis_port       = var.redis_port

  # Resource Tags
  tags = var.tags
}

# ============================================================
# IAM Module
# ============================================================

module "iam" {
  source = "./modules/iam"

  # EKS Cluster IAM Role
  cluster_name = var.eks_cluster_name

  # EBS CSI Driver IAM Role
  name_prefix = var.name

  # Resource Tags
  tags = var.tags
}

# ============================================================
# Amazon EKS Module
# ============================================================

module "eks" {
  source = "./modules/eks"

  # EKS Cluster Configuration
  cluster_name       = var.eks_cluster_name
  kubernetes_version = var.eks_kubernetes_version

  # IAM Role Managed by the IAM Module
  cluster_role_arn = module.iam.cluster_role_arn

  # VPC and Private Subnets
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids

  # Kubernetes API Endpoint Access
  endpoint_private_access = true
  endpoint_public_access  = true

  endpoint_public_access_cidrs = var.eks_endpoint_public_access_cidrs

  # Application and Redis Managed Node Group
  app_redis_instance_types = var.app_redis_instance_types

  app_redis_node_desired_size = var.app_redis_node_desired_size
  app_redis_node_min_size     = var.app_redis_node_min_size
  app_redis_node_max_size     = var.app_redis_node_max_size

  # PostgreSQL Managed Node Group
  postgres_instance_types = var.postgres_instance_types

  postgres_node_desired_size = var.postgres_node_desired_size
  postgres_node_min_size     = var.postgres_node_min_size
  postgres_node_max_size     = var.postgres_node_max_size

  # Shared Node Configuration
  node_capacity_type = var.eks_node_capacity_type
  node_disk_size     = var.eks_node_disk_size

  # EKS Control Plane Logging
  log_retention_days = 7

  # Resource Tags
  tags = var.tags
}

# ============================================================
# EKS Add-ons Module
# ============================================================
# Enable after modules/eks-addons has been implemented.
#
# module "eks_addons" {
#   source = "./modules/eks-addons"
#
#   cluster_name            = var.eks_cluster_name
#   kubernetes_version      = var.eks_kubernetes_version
#   ebs_csi_driver_role_arn = module.iam.ebs_csi_driver_role_arn
#
#   tags = var.tags
# }

# ============================================================
# Application Load Balancer Module
# ============================================================

module "alb" {
  source = "./modules/alb"

  name              = "${var.name}-alb"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  security_group_id = module.security_groups.alb_security_group_id

  # Application Target Configuration
  target_port          = var.application_port
  health_check_path    = "/"
  health_check_matcher = "200"

  # ALB Configuration
  enable_deletion_protection = false
  deregistration_delay       = 30

  # Resource Tags
  tags = var.tags
}

# ============================================================
# AWS Certificate Manager (ACM) Module
# ============================================================

module "acm" {
  source = "./modules/acm"

  name        = var.name
  domain_name = "cloudaiops.site"

  subject_alternative_names = [
    "www.cloudaiops.site"
  ]

  # Resource Tags
  tags = var.tags
}

# ============================================================
# HashiCorp Vault Module
# ============================================================

module "vault" {
  source = "./modules/vault"

  release_name    = "vault"
  namespace       = "vault"
  environment     = var.environment
  chart_version   = var.vault_chart_version
  vault_image_tag = var.vault_image_tag

  # Persistent Storage
  storage_size  = "10Gi"
  storage_class = ""

  # Vault Features
  injector_enabled = true
  ui_enabled       = true

  # Resource Requests and Limits
  cpu_request    = "250m"
  memory_request = "256Mi"
  cpu_limit      = "1000m"
  memory_limit   = "1Gi"
}

# ============================================================
# Amazon Elastic Container Registry (ECR) Module
# ============================================================

module "ecr" {
  source = "./modules/ecr"

  # ECR Repository Configuration
  repository_names = var.ecr_repository_names

  # Image Configuration
  image_tag_mutability = "IMMUTABLE"
  scan_on_push         = true
  max_tagged_images    = 30

  # Resource Tags
  tags = var.tags
}