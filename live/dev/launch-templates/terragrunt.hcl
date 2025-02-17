include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules/launch-templates///"
}

# inputs = {
#   node_role_arn    = dependency.security.outputs.node_role_arn
#   cluster_name     = dependency.eks_cluster.outputs.cluster_name  # Assuming you have a dependency for your EKS cluster outputs.
  
#   node_group_name  = "frontend"
#   subnet_ids       = dependency.networking.outputs.private_subnets
#   desired_size     = 2
#   min_size         = 1
#   max_size         = 3
#   instance_types   = ["t3.medium"]
#   disk_size        = 20
#   ec2_ssh_key      = ""                
#   source_security_group_ids = []        
#   max_unavailable  = 1

# }
