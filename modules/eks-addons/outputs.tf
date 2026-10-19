# ---------------------------------------------------------
# Pod Identity Agent Outputs
# ---------------------------------------------------------

output "pod_identity_agent_arn" {
  description = "ARN of the EKS Pod Identity Agent add-on."
  value       = aws_eks_addon.pod_identity_agent.arn
}

output "pod_identity_agent_version" {
  description = "Installed version of the EKS Pod Identity Agent."
  value       = aws_eks_addon.pod_identity_agent.addon_version
}

output "pod_identity_agent_status" {
  description = "Status of the EKS Pod Identity Agent add-on."
  value       = aws_eks_addon.pod_identity_agent.status
}

# ---------------------------------------------------------
# EBS CSI Driver Outputs
# ---------------------------------------------------------

output "ebs_csi_driver_arn" {
  description = "ARN of the Amazon EBS CSI Driver add-on."
  value       = aws_eks_addon.ebs_csi_driver.arn
}

output "ebs_csi_driver_version" {
  description = "Installed version of the Amazon EBS CSI Driver."
  value       = aws_eks_addon.ebs_csi_driver.addon_version
}

output "ebs_csi_driver_status" {
  description = "Status of the Amazon EBS CSI Driver add-on."
  value       = aws_eks_addon.ebs_csi_driver.status
}
