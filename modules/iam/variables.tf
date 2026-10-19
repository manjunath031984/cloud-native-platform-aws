# ============================================================
# IAM Module Variables
# ============================================================

variable "cluster_name" {
  description = "Name of the EKS cluster whose IAM role is being created."
  type        = string
}

variable "name_prefix" {
  description = "Prefix used to name IAM resources."
  type        = string
}

variable "ebs_csi_policy_arn" {
  description = "AWS-managed IAM policy ARN for the EBS CSI Driver."
  type        = string
  default     = "arn:aws:iam::aws:policy/AmazonEBSCSIDriverPolicyV2"
}

variable "tags" {
  description = "Tags applied to IAM resources."
  type        = map(string)
  default     = {}
}
