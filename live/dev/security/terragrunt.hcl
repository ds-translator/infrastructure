include {
  path = find_in_parent_folders("root.hcl")
}


terraform {
  source = "../../../modules/security"
}

inputs = {
  
#   environment      = include.root.inputs.environment
#   project_name     = include.root.inputs.project_name
#   extra_tags       = {}                # Any additional tags you want to attach
}
