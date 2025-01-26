locals {
  # Parse the file path to get the env name: for example, env will be "dev" in the dev folder, "stage" in the stage folder, # and so on.

  parsed = regex(".*/live/(?P<env>.*?)/.*", get_terragrunt_dir())
  env    = local.parsed.env
}

# Configure S3 as a backend
remote_state {
  backend = "s3"
  config = {
    bucket = "example-buckets-${local.env}"
    region = "eu-central-1"
    key    = "${path_relative_to_include()}/terraform.tfstate"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}