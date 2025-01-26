
include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../eks-cluster"
}

inputs = {
  cluster_name = "dst-cluster-dev"
  env = "dev"
  node_count = 3
}