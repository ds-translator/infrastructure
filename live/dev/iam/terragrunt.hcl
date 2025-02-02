
include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules/iam"
}

inputs = {
  project_name = "datascientest-translator"
  environment = "dev"

}