include {
  path = find_in_parent_folders("root.hcl")
}

dependency "ec2_templates" {
  config_path = "../../global/ec2-templates"
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
  ec2_ssh_key      = ""                
  source_security_group_ids = []        
  max_unavailable  = 1

  launch_template_id = dependency.ec2_templates.outputs.launch_template_id

}
