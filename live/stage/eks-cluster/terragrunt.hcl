
include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../eks-cluster"
}

inputs = {
  project_name = "datascientest-translator"
  environment = "stage"
  node_count = 3
  cidr = "10.40.0.0/16"
  private_subnets = ["10.40.32.0/20", "10.40.48.0/20"]
  public_subnets  = ["10.40.0.0/20", "10.40.16.0/20"]
}