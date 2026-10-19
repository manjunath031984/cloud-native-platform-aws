# ---------------------------------------------------------
# EKS Cluster Configuration
# ---------------------------------------------------------

variable "cluster_name" {
  description = "Name of the existing Amazon EKS cluster."
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version of the EKS cluster."
  type        = string
}

# ---------------------------------------------------------
# EBS CSI Driver IAM Configuration
# ---------------------------------------------------------

variable "ebs_csi_driver_role_arn" {
  description = "ARN of the IAM role assigned to the EBS CSI Driver through EKS Pod Identity."
  type        = string
}

# ---------------------------------------------------------
# Resource Tags
# ---------------------------------------------------------

variable "tags" {
  description = "Tags applied to EKS add-on resources."
  type        = map(string)
  default     = {}
}