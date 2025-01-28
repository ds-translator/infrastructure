module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.33.0"
  cluster_name    = var.cluster_name
  cluster_version = "1.31"
  subnet_ids      = var.private_subnets
  vpc_id          = var.vpc_id

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    frontend = {
      labels = {
        environment = var.environment
        role        = "worker"
        app         = "frontend"
      }

      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 3
      desired_size = 2

      tags = {
        Name        = "${var.environment}-eks-node-group-frontend"
        Environment = var.environment
      }
    }
    backend = {
      labels = {
        environment = var.environment
        role        = "worker"
        app         = "backend"
      }

      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 3
      desired_size = 2

      tags = {
        Name        = "${var.environment}-eks-node-group-backend"
        Environment = var.environment
      }
    }
  }

  tags = {
    Environment = var.environment
    Name        = "${var.environment}-eks-cluster"
    Project     = var.project_name
  }
}
