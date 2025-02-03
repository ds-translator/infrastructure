include {
  path = find_in_parent_folders("root.hcl")
}

dependency "security" {
  config_path = "../security"
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
  node_role_arn    = dependency.security.outputs.node_role_arn
  cluster_name     = dependency.eks_cluster.outputs.cluster_name  # Assuming you have a dependency for your EKS cluster outputs.
  
  node_group_name  = "frontend"
  subnet_ids       = dependency.networking.outputs.private_subnets
  desired_size     = 2
  min_size         = 1
  max_size         = 3
  instance_types   = ["t3.medium"]
  disk_size        = 20
  ec2_ssh_key      = ""                # Provide your EC2 SSH key name if you need SSH access
  source_security_group_ids = []        # Provide SG IDs if SSH access is configured
  max_unavailable  = 1

}
