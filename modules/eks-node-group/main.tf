provider "aws" {
  region = var.region
}

resource "aws_eks_node_group" "this" {
  cluster_name    = var.cluster_name
  node_group_name = "${var.project_id}-${var.environment}-eks-ng-${var.node_group_name}"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.desired_size
    min_size     = var.min_size
    max_size     = var.max_size
  }

  launch_template {
    name    = "${var.project_id}-eks-node-template"
    version = "$Latest"
  }

  instance_types = var.instance_types
  # disk_size      = var.disk_size

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

 

  tags = {
    "Environment" = var.environment,
    "Project"     = var.project_name
    "Name"        = "${var.project_id}-${var.environment}-eks-node-frontend"
    "NodeGroup"   = var.node_group_name
  }
}
