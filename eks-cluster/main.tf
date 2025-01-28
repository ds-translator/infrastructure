

data "aws_availability_zones" "available" {
  state = "available"
}

# Select only the first two availability zones
locals {
  selected_azs = slice(data.aws_availability_zones.available.names, 0, 2)
}

output "selected_azs" {
  value = local.selected_azs
}

module "vpc" {
  source      = "./modules/vpc"
  azs         = local.selected_azs
  environment = var.environment
  name        = "dst-vpc-${var.environment}"
}

module "eks" {
  source          = "./modules/eks"
  cluster_name    = "dst-cluster-${var.environment}"
  private_subnets = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id
  environment     = var.environment

}

