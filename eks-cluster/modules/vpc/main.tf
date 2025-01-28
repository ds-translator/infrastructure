module "vpc" {

  name = "dst-vpc-${var.environment}"

  source = "terraform-aws-modules/vpc/aws"

  cidr = var.cidr

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_vpn_gateway = false

  tags = {
    Environment = var.environment
    Name = "${var.environment}-eks-cluster"
    Project = var.project_name
  }
}
