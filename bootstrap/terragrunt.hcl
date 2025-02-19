terraform {
  source = "."  # Path to your bootstrap Terraform module
}

inputs = {
  environments = ["dev", "stage", "prod"]
  aws_region             = "us-east-1"
  terraform_state_bucket = "dst-bootstrap-terraform-states"
  terraform_locks_table = "dst-bootstrap-terraform-locks" 
  project_id = "dst"
  project_name = "datascientest-translator"
  github_repo = "ds-translator/infrastructure"
}

remote_state {
  backend = "s3"
  config = {
    bucket         = "dst-bootstrap-terraform-states"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "dst-bootstrap-terraform-locks"
  }
}

