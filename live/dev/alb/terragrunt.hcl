
include {
  path = find_in_parent_folders("root.hcl")
}


dependency "networking" {
  # Adjust the path according to your directory structure.
  config_path = "../networking"
}

terraform {
  source = "../../../modules/alb"
}

inputs = {
  vpc_id              = dependency.networking.outputs.vpc_id
  subnets             = dependency.networking.outputs.public_subnets
}
