inputs = {
  project_name = "datascientest-translator"
  project_id = "dst"
  environment = regex(".*/live/(?P<env>.*?)/.*", get_terragrunt_dir()).env
  # env    = local.parsed.env
  # bucket_name  = "${local.project_name}-terraform"
  region = "us-east-1"
}

locals {
  project_id = "dst"
}

remote_state {
  backend = "s3"
  config = {
    # dst-terraform-state is deleted but throws errors
    bucket = "dst-terraform-states-1"
    region = "us-east-1"
    key    = "${path_relative_to_include()}/terraform.tfstate"
    dynamodb_table = "dst-terraform-locks"
    encrypt = true    
    # does not matter
    # skip_region_validation = true
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}