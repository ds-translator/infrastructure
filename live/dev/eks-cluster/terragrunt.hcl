
include {
  path = find_in_parent_folders("root.hcl")
}

dependency "networking" {
  config_path = "../networking"

  mock_outputs = {
    vpc_id = "vpc-1939479"
    private_subnets = ["subnet-12345678", "subnet-87654321"]
  }  
  mock_outputs_merge_strategy_with_state = "no_merge"
}

terraform {
  source = "../../../modules/eks-cluster///"
}

inputs = {
  vpc_id  = dependency.networking.outputs.vpc_id
  subnet_ids         = dependency.networking.outputs.private_subnets
  kubernetes_version = "1.32"
}
