include {
  path = find_in_parent_folders("root.hcl")
}

dependency "security" {
  config_path = "../security"

  mock_outputs = {
    node_role_name = "mock-eks-node-group-role"
    node_role_arn  = "arn:aws:iam::123456789012:role/mock-eks-node-group-role"
  }  
}

dependency "networking" {
  config_path = "../networking"

  mock_outputs = {
    private_subnets = ["subnet-12345678", "subnet-87654321"]
  }    
}

dependency "eks_cluster" {
  config_path = "../eks-cluster"

  mock_outputs = {
    cluster_name = "dst-stage-cluster"
  }
}

terraform {
  source = "../../../modules/eks-node-group///"
}

inputs = {
  node_role_arn    = dependency.security.outputs.node_role_arn
  cluster_name     = dependency.eks_cluster.outputs.cluster_name 
  
  node_group_name  = "alb"
  subnet_ids       = dependency.networking.outputs.private_subnets
  desired_size     = 2
  min_size         = 2
  max_size         = 3
  instance_types   = ["t3.medium"]
  disk_size        = 20
  ec2_ssh_key      = ""                
  source_security_group_ids = []        
  max_unavailable  = 1
  # labels           = {
  #   "alb-controller" = "true"
  # }  
  # taint = {
  #   key = "dedicated"
  #   value = "alb"
  #   effect = "NO_SCHEDULE"
  # }

  launch_template = "dst-eks-node-template"

  ami_type = "AL2_x86_64"

  labels = {
    "alb-controller"  = "true"
    "role" = "load-balancer"
  }

}
