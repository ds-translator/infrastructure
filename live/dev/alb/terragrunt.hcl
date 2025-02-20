
include {
  path = find_in_parent_folders("root.hcl")
}


dependency "networking" {
  # Adjust the path according to your directory structure.
  config_path = "../networking"

  mock_outputs = {
    vpc_id = "vpc-87654321"
    public_subnets = ["subnet-12345678", "subnet-87654321"]

  }    
}

dependency "eks-cluster" {

  mock_outputs_allowed_terraform_commands = ["validate"]

  # Adjust the path according to your directory structure.
  config_path = "../eks-cluster"

  mock_outputs = {
    cluster_name                        = "dst-dev-cluster"
    cluster_endpoint                    = "https://EXAMPLE.gr7.us-west-2.eks.amazonaws.com"
    cluster_token                       = "dummy-token-12345"
    cluster_certificate_authority_data  = <<EOF
-----BEGIN CERTIFICATE-----
c2pkbmFrc2R2bmtqc2ZkdnNkZmJhc2R2YXNmdnNkZmJ2c2RmYnNkZmJzZGZic2RmYmRzZmI=
-----END CERTIFICATE-----
EOF
    oidc_provider_arn                  = "arn:aws:iam::123456789012:oidc-provider/oidc.eks.us-west-2.amazonaws.com/id/EXAMPLE"
  }
}

terraform {
  source = "../../../modules/alb///"
}

inputs = {
  vpc_id       = dependency.networking.outputs.vpc_id
  subnets      = dependency.networking.outputs.public_subnets

  cluster_name = dependency.eks-cluster.outputs.cluster_name
  cluster_endpoint = dependency.eks-cluster.outputs.cluster_endpoint
  cluster_token = dependency.eks-cluster.outputs.cluster_token
  oidc_provider_arn = dependency.eks-cluster.outputs.oidc_provider_arn
  cluster_certificate_authority_data = dependency.eks-cluster.outputs.cluster_certificate_authority_data

}
