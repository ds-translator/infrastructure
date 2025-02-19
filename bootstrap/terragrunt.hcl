terraform {
  source = "."  # Path to your bootstrap Terraform module
}


remote_state {
  backend = "s3"
  config = {
    bucket         = "dst-bootstrap-terraform-states"  # Your S3 bucket name
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"                        # Your chosen region
    encrypt        = true
    dynamodb_table = "dst-bootstrap-terraform-locks"             # Your DynamoDB table for state locking
  }
}

inputs = {
  aws_region          = "us-east-1"                           # Desired region
  bucket_name         = "dst-bootstrap-terraform-states"      # Globally unique S3 bucket name
  dynamodb_table_name = "dst-bootstrap-terraform-locks"                # DynamoDB table for state locking
}