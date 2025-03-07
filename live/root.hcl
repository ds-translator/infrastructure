locals {
  project_id = "dst"
  region     = "us-east-1"
}

inputs = {
  project_name = "datascientest-translator"
  project_id = local.project_id
  environment = regex(".*/live/(?P<env>.*?)/.*", get_terragrunt_dir()).env
  region = local.region
}

remote_state {
  backend = "s3"
  config = {
    bucket = "dst-terraform-states-1"
    region = local.region
    key    = "${path_relative_to_include()}/terraform.tfstate"
    dynamodb_table = "dst-terraform-locks"
    encrypt = true    
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}