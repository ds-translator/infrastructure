
include {
  path = find_in_parent_folders("root.hcl")
}


dependency "networking" {
  # Adjust the path according to your directory structure.
  config_path = "../networking"
}

dependency "eks-cluster" {
  # Adjust the path according to your directory structure.
  config_path = "../eks-cluster"
}

terraform {
  source = "../../../modules/alb"
}

inputs = {
  vpc_id       = dependency.networking.outputs.vpc_id
  subnets      = dependency.networking.outputs.public_subnets

  cluster_name = dependency.eks-cluster.outputs.cluster_name
  cluster_endpoint = dependency.eks-cluster.outputs.cluster_endpoint
  cluster_token = dependency.eks-cluster.outputs.cluster_token
  cluster_certificate_authority_data = dependency.eks-cluster.outputs.cluster_certificate_authority_data
  oidc_provider_arn = dependency.eks-cluster.outputs.oidc_provider_arn
}
