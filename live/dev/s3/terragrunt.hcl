include {
  path = find_in_parent_folders("root.hcl")
}


dependency "networking" {
  config_path = "../networking"

  mock_outputs = {
    private_subnets = ["subnet-12345678", "subnet-87654321"]
  }    
}


terraform {
  source = "../../../modules/s3///"
}

inputs = {
  


}
