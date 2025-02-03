
include {
  path = find_in_parent_folders("root.hcl")
}


dependency "networking" {
  # Adjust the path according to your directory structure.
  config_path = "../networking"
}

dependency "eks_cluster" {
  config_path = "../eks-cluster"
}

dependency "alb" {
  config_path = "../alb"
}

terraform {
  source = "../../../modules/frontend"
}

inputs = {
  # project_name       = "my-eks-project"
  # environment        = include.root.locals.env       # If defined at your root Terragrunt config
  # cluster_name       = "${include.root.inputs.project_id}"
  # -${include.root.inputs.environment}-eks-cluster"

  # cluster_role_arn   = "arn:aws:iam::123456789012:role/eksClusterRole"  # Replace with your role ARN
  cluster_name     = dependency.eks_cluster.outputs.cluster_name  # Assuming you have a dependency for your EKS cluster outputs.
  cluster_endpoint     = dependency.eks_cluster.outputs.cluster_endpoint  # Assuming you have a dependency for your EKS cluster outputs.
  cluster_certificate_authority_data     = dependency.eks_cluster.outputs.cluster_certificate_authority_data  # Assuming you have a dependency for your EKS cluster outputs.

  subnet_ids         = dependency.networking.outputs.private_subnets  # Assuming you get these from a VPC module dependency
  
  target_group = dependency.alb.outputs.target_group_arn
  
  kubernetes_version = "1.32"
}
