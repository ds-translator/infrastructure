module "vpc" {
#   source = "./modules/vpc"
  
#   environment = var.environment
  name = "dst-vpc-${var.environment}"

  source = "terraform-aws-modules/vpc/aws"

  cidr = "10.0.0.0/16"

  azs             = var.azs
  private_subnets = ["10.0.0.0/22", "10.0.4.0/22"]
  public_subnets  = ["10.0.100.0/22", "10.0.104.0/22"]

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_vpn_gateway = false
  
  tags = {
    Environment = var.environment
  }
}