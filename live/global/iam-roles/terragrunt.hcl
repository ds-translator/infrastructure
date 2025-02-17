
include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules/iam-roles"
}
locals {
  # environment_vars = read_terragrunt_config(find_in_parent_folders("root.hcl"))
}

inputs = {
  group_name = "dst-terraform-users"
  # project_name = local.project_name
  # environment = local.environment_vars.locals.env 
}