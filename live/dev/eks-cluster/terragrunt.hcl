
include {
  path = find_in_parent_folders("root.hcl")
}


dependency "networking" {
  # Adjust the path according to your directory structure.
  config_path = "../networking"

  mock_outputs = {
    vpc_id = "vpc-1939479"
    private_subnets = ["subnet-12345678", "subnet-87654321"]
  }  
}

terraform {
  source = "../../../modules/eks-cluster///"
}

inputs = {
  # project_name       = "my-eks-project"
  # environment        = include.root.locals.env       # If defined at your root Terragrunt config
  # cluster_name       = "${include.root.inputs.project_id}"
  # -${include.root.inputs.environment}-eks-cluster"

  # cluster_role_arn   = "arn:aws:iam::123456789012:role/eksClusterRole"  # Replace with your role ARN
  vpc_id  = dependency.networking.outputs.vpc_id
  subnet_ids         = dependency.networking.outputs.private_subnets  # Assuming you get these from a VPC module dependency
  kubernetes_version = "1.32"
}
