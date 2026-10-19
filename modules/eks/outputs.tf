# =========================================================
# EKS Cluster Outputs
# =========================================================

output "cluster_name" {
  description = "Name of the EKS cluster."
  value       = aws_eks_cluster.this.name
}

output "cluster_arn" {
  description = "ARN of the EKS cluster."
  value       = aws_eks_cluster.this.arn
}

output "cluster_endpoint" {
  description = "Kubernetes API endpoint."
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_version" {
  description = "Kubernetes version running on the EKS cluster."
  value       = aws_eks_cluster.this.version
}

output "cluster_certificate_authority_data" {
  description = "Base64-encoded certificate authority data for the Kubernetes API."
  value       = aws_eks_cluster.this.certificate_authority[0].data
  sensitive   = true
}

output "cluster_security_group_id" {
  description = "Security group ID managed by EKS for the cluster."
  value       = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}

# =========================================================
# EKS IAM Role Outputs
# =========================================================

output "cluster_iam_role_arn" {
  description = "ARN of the EKS cluster IAM role managed by the IAM module."
  value       = var.cluster_role_arn
}

output "node_iam_role_arn" {
  description = "IAM role ARN assumed by EKS worker nodes."
  value       = aws_iam_role.node.arn
}

# =========================================================
# Application + Redis Node Group Outputs
# =========================================================

output "app_redis_node_group_name" {
  description = "Name of the application and Redis managed node group."
  value       = aws_eks_node_group.app_redis.node_group_name
}

output "app_redis_node_group_arn" {
  description = "ARN of the application and Redis managed node group."
  value       = aws_eks_node_group.app_redis.arn
}

output "app_redis_node_group_status" {
  description = "Status of the application and Redis managed node group."
  value       = aws_eks_node_group.app_redis.status
}

# =========================================================
# PostgreSQL Node Group Outputs
# =========================================================

output "postgres_node_group_name" {
  description = "Name of the PostgreSQL managed node group."
  value       = aws_eks_node_group.postgres.node_group_name
}

output "postgres_node_group_arn" {
  description = "ARN of the PostgreSQL managed node group."
  value       = aws_eks_node_group.postgres.arn
}

output "postgres_node_group_status" {
  description = "Status of the PostgreSQL managed node group."
  value       = aws_eks_node_group.postgres.status
}