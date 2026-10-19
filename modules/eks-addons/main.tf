# ---------------------------------------------------------
# EKS Add-on Versions
# ---------------------------------------------------------

data "aws_eks_addon_version" "pod_identity_agent" {
  addon_name         = "eks-pod-identity-agent"
  kubernetes_version = var.kubernetes_version
  most_recent        = true
}

data "aws_eks_addon_version" "ebs_csi_driver" {
  addon_name         = "aws-ebs-csi-driver"
  kubernetes_version = var.kubernetes_version
  most_recent        = true
}

# ---------------------------------------------------------
# EKS Add-on: Pod Identity Agent
# ---------------------------------------------------------

resource "aws_eks_addon" "pod_identity_agent" {
  cluster_name  = var.cluster_name
  addon_name    = "eks-pod-identity-agent"
  addon_version = data.aws_eks_addon_version.pod_identity_agent.version

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "PRESERVE"

  tags = var.tags
}

# ---------------------------------------------------------
# EKS Add-on: Amazon EBS CSI Driver
# ---------------------------------------------------------

resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name  = var.cluster_name
  addon_name    = "aws-ebs-csi-driver"
  addon_version = data.aws_eks_addon_version.ebs_csi_driver.version

  # Give the EBS CSI controller access to AWS APIs through
  # EKS Pod Identity rather than relying on node permissions.
  pod_identity_association {
    service_account = "ebs-csi-controller-sa"
    role_arn        = var.ebs_csi_driver_role_arn
  }

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "PRESERVE"

  tags = var.tags

  depends_on = [
    aws_eks_addon.pod_identity_agent
  ]
}