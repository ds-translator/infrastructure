
include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../eks-cluster"
}

inputs = {
  instance_name = "eks-cluster-dev"
  node_count = 3
}