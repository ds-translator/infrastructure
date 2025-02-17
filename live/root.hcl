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
    bucket = "dst-terraform-state-2"
    region = "us-east-1"
    key    = "${path_relative_to_include()}/terraform.tfstate"
    dynamodb_table = "dst-terraform-locks"
    encrypt = true    
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}