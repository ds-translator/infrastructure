
include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules/iam-users"
}


inputs = {
  group_name = "dst-terraform-users"
  users      = ["dst-janod", "dst-julian", "dst-loay", "dst-patrick", "dst-github"]
}