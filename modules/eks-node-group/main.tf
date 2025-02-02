#############################
# Create IAM Role for Node Group
#############################
resource "aws_iam_role" "node_group_role" {
  name = "${var.project_id}-${var.environment}-eks-node-group-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Environment = var.environment,
    Project     = var.project_name,
  }
}

# Attach the AmazonEKSWorkerNodePolicy to allow necessary EKS worker node actions.
resource "aws_iam_role_policy_attachment" "node_worker_policy" {
  role       = aws_iam_role.node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

# Attach the AmazonEKS_CNI_Policy for networking functionality.
resource "aws_iam_role_policy_attachment" "node_cni_policy" {
  role       = aws_iam_role.node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# Attach the AmazonEC2ContainerRegistryReadOnly policy for pulling container images.
resource "aws_iam_role_policy_attachment" "node_registry_policy" {
  role       = aws_iam_role.node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}



resource "aws_eks_node_group" "this" {
  cluster_name    = var.cluster_name
  node_group_name = "${var.project_id}-${var.environment}-eks-node-group"
  node_role_arn   = aws_iam_role.node_group_role.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.desired_size
    min_size     = var.min_size
    max_size     = var.max_size
  }

  instance_types = var.instance_types
  disk_size      = var.disk_size

  # (Optional) Enable remote access for SSH into worker nodes.
#   dynamic "remote_access" {
#     for_each = var.ec2_ssh_key != "" && length(var.source_security_group_ids) > 0 ? [1] : []
#     content {
#       ec2_ssh_key               = var.ec2_ssh_key
#       source_security_group_ids = var.source_security_group_ids
#     }
#   }

  update_config {
    max_unavailable = var.max_unavailable
  }

  tags = merge(
    {
      "Environment" = var.environment,
      "Project"     = var.project_name
    #   "NodeGroup"   = var.node_group_name
    },
    var.extra_tags
  )
}
