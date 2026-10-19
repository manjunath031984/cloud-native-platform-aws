# ============================================================
# EKS Cluster IAM Role Outputs
# ============================================================

output "cluster_role_name" {
  description = "Name of the EKS cluster IAM role."
  value       = aws_iam_role.cluster.name
}

output "cluster_role_arn" {
  description = "ARN of the EKS cluster IAM role."
  value       = aws_iam_role.cluster.arn
}

# ============================================================
# EBS CSI Driver IAM Role Outputs
# ============================================================

output "ebs_csi_driver_role_name" {
  description = "Name of the EBS CSI Driver IAM role."
  value       = aws_iam_role.ebs_csi_driver.name
}

output "ebs_csi_driver_role_arn" {
  description = "ARN of the EBS CSI Driver IAM role."
  value       = aws_iam_role.ebs_csi_driver.arn
}