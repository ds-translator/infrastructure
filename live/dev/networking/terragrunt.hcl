include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules/networking///"
}

inputs = {
  vpc_cidr        = "10.30.0.0/16"
  private_subnets = ["10.30.32.0/20", "10.30.48.0/20"]
  public_subnets  = ["10.30.0.0/20", "10.30.16.0/20"]
}