
include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules/networking"
}
locals {
  # environment_vars = read_terragrunt_config(find_in_parent_folders("root.hcl"))
}

inputs = {
  # project_name = local.project_name
  # environment = local.environment_vars.locals.env 
  vpc_cidr = "10.30.0.0/16"
  private_subnets = ["10.30.32.0/20", "10.30.48.0/20"]
  public_subnets  = ["10.30.0.0/20", "10.30.16.0/20"]  
}