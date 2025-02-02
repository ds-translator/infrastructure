inputs = {
  project_name = "datascientest-translator"
  project_id = "dst"
  environment = regex(".*/live/(?P<env>.*?)/.*", get_terragrunt_dir()).env
  # env    = local.parsed.env
  # bucket_name  = "${local.project_name}-terraform"
  region = "eu-central-1"
}

remote_state {
  backend = "s3"
  config = {
    bucket = "terraform-state-datascientest-translator"
    region = "eu-central-1"
    key    = "${path_relative_to_include()}/terraform.tfstate"
    dynamodb_table = "terraform-locks"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}