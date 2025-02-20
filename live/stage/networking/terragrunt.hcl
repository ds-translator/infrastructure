include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules/networking///"
}

inputs = {
  vpc_cidr = "10.40.0.0/16"
  private_subnets = ["10.40.32.0/20", "10.40.48.0/20"]
  public_subnets  = ["10.40.0.0/20", "10.40.16.0/20"]
}