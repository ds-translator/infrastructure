include {
  path = find_in_parent_folders("root.hcl")
}

dependency "networking" {
  config_path = "../networking"
}

dependency "eks_cluster" {
  config_path = "../eks-cluster"
}

terraform {
  source = "../../../modules/eks-node-group"
}

inputs = {
  cluster_name     = dependency.eks_cluster.outputs.cluster_name  # Assuming you have a dependency for your EKS cluster outputs.
#   node_group_name  = "${include.root.inputs.project_id}-${include.root.inputs.environment}-eks-ng"
  node_group_name = "eks_node_group"
#   node_role_arn    = dependency.eks_iam_role.outputs.role_arn         # If you're managing the IAM role in a separate module or dependency.
  subnet_ids       = dependency.networking.outputs.private_subnets
  desired_size     = 2
  min_size         = 1
  max_size         = 3
  instance_types   = ["t3.medium"]
  disk_size        = 20
  ec2_ssh_key      = ""                # Provide your EC2 SSH key name if you need SSH access
  source_security_group_ids = []        # Provide SG IDs if SSH access is configured
  max_unavailable  = 1
#   environment      = include.root.inputs.environment
#   project_name     = include.root.inputs.project_name
#   extra_tags       = {}                # Any additional tags you want to attach
}
