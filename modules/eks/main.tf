# ---------------------------------------------------------
# EKS Cluster IAM Role
# ---------------------------------------------------------

data "aws_iam_policy_document" "cluster_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "cluster" {
  name               = "${var.cluster_name}-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.cluster_assume_role.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "cluster_policy" {
  role       = aws_iam_role.cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# ---------------------------------------------------------
# CloudWatch Control-Plane Logs
# ---------------------------------------------------------

resource "aws_cloudwatch_log_group" "cluster" {
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = var.log_retention_days

  tags = var.tags
}

# ---------------------------------------------------------
# EKS Cluster
# ---------------------------------------------------------

resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster.arn
  version  = var.kubernetes_version

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.endpoint_public_access_cidrs
  }

  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  tags = var.tags

  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy,
    aws_cloudwatch_log_group.cluster
  ]

  lifecycle {
    precondition {
      condition = (
        var.endpoint_public_access ||
        var.endpoint_private_access
      )

      error_message = "At least one EKS API endpoint access option must be enabled."
    }
  }
}

# ---------------------------------------------------------
# Managed Node Group IAM Role
# ---------------------------------------------------------

data "aws_iam_policy_document" "node_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "node" {
  name               = "${var.cluster_name}-node-role"
  assume_role_policy = data.aws_iam_policy_document.node_assume_role.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "worker_node_policy" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "container_registry_policy" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
}

resource "aws_iam_role_policy_attachment" "cni_policy" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# ---------------------------------------------------------
# EKS Managed Node Group: Application + Redis
# ---------------------------------------------------------

resource "aws_eks_node_group" "app_redis" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}-app-redis"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = var.private_subnet_ids

  instance_types = var.app_redis_instance_types
  capacity_type  = var.node_capacity_type
  disk_size      = var.node_disk_size

  scaling_config {
    desired_size = var.app_redis_node_desired_size
    min_size     = var.app_redis_node_min_size
    max_size     = var.app_redis_node_max_size
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    workload = "app-redis"
  }

  tags = merge(var.tags, {
    Workload = "app-redis"
  })

  depends_on = [
    aws_iam_role_policy_attachment.worker_node_policy,
    aws_iam_role_policy_attachment.container_registry_policy,
    aws_iam_role_policy_attachment.cni_policy
  ]

  lifecycle {
    precondition {
      condition = (
        var.app_redis_node_min_size <= var.app_redis_node_desired_size &&
        var.app_redis_node_desired_size <= var.app_redis_node_max_size
      )

      error_message = "App/Redis node group sizes must satisfy min_size <= desired_size <= max_size."
    }
  }
}

# ---------------------------------------------------------
# EKS Managed Node Group: PostgreSQL
# ---------------------------------------------------------

resource "aws_eks_node_group" "postgres" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}-postgres"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = var.private_subnet_ids

  instance_types = var.postgres_instance_types
  capacity_type  = var.node_capacity_type
  disk_size      = var.node_disk_size

  scaling_config {
    desired_size = var.postgres_node_desired_size
    min_size     = var.postgres_node_min_size
    max_size     = var.postgres_node_max_size
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    workload = "postgres"
  }

  tags = merge(var.tags, {
    Workload = "postgres"
  })

  depends_on = [
    aws_iam_role_policy_attachment.worker_node_policy,
    aws_iam_role_policy_attachment.container_registry_policy,
    aws_iam_role_policy_attachment.cni_policy
  ]

  lifecycle {
    precondition {
      condition = (
        var.postgres_node_min_size <= var.postgres_node_desired_size &&
        var.postgres_node_desired_size <= var.postgres_node_max_size
      )

      error_message = "PostgreSQL node group sizes must satisfy min_size <= desired_size <= max_size."
    }
  }
}
