# ---------------------------------------------------------
# EKS Cluster IAM Role
# ---------------------------------------------------------

# Trust policy for the Amazon EKS control plane.

data "aws_iam_policy_document" "cluster_assume_role" {
  statement {
    sid     = "AllowEKSClusterAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

# IAM role used by the EKS control plane.

resource "aws_iam_role" "cluster" {
  name               = "${var.cluster_name}-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.cluster_assume_role.json
  description        = "IAM role used by the Amazon EKS control plane"

  tags = var.tags
}

# Required Amazon EKS cluster permissions.

resource "aws_iam_role_policy_attachment" "cluster_policy" {
  role       = aws_iam_role.cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# ---------------------------------------------------------
# EBS CSI Driver IAM Role
# ---------------------------------------------------------

# Trust policy for EKS Pod Identity.

data "aws_iam_policy_document" "ebs_csi_assume_role" {
  statement {
    sid    = "AllowEKSPodIdentity"
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }
  }
}

# IAM role used by the EBS CSI Driver.

resource "aws_iam_role" "ebs_csi_driver" {
  name                 = "${var.name_prefix}-ebs-csi-driver"
  assume_role_policy   = data.aws_iam_policy_document.ebs_csi_assume_role.json
  description          = "IAM role for the Amazon EBS CSI Driver"
  max_session_duration = 3600

  tags = var.tags
}

# Retrieve the AWS-managed EBS CSI policy.

data "aws_iam_policy" "ebs_csi_driver" {
  arn = var.ebs_csi_policy_arn
}

# Attach EBS volume management permissions.

resource "aws_iam_role_policy_attachment" "ebs_csi_driver" {
  role       = aws_iam_role.ebs_csi_driver.name
  policy_arn = data.aws_iam_policy.ebs_csi_driver.arn
}