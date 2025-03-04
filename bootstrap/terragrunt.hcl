terraform {
  source = "."  # Path to your bootstrap Terraform module
}

inputs = {
  environments = ["dev", "stage", "prod"]
  branches = ["develop", "release", "main"]
  aws_region             = "us-east-1"
  terraform_state_bucket = "dst-terraform-states-1"
  terraform_locks_table = "dst-terraform-locks" 
  project_id = "dst"
  project_name = "datascientest-translator"
  github_infrastructure_repo = "ds-translator/infrastructure"
  github_deployment_repo = "ds-translator/deployment"
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

