include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules/networking///"
}

inputs = {
  vpc_cidr        = "10.50.0.0/16"
  private_subnets = ["10.50.32.0/20", "10.50.48.0/20"]
  public_subnets  = ["10.50.0.0/20", "10.50.16.0/20"]
}