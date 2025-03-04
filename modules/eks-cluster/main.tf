provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

# module "ebs_csi_irsa_role" {
#   source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

#   role_name             = "${var.project_id}-${var.environment}-cluster-ebs-csi"
#   attach_ebs_csi_policy = true

#   oidc_providers = {
#     ex = {
#       provider_arn               = module.eks.oidc_provider_arn
#       namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
#     }
#   }
# }


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name    = "${var.project_id}-${var.environment}-cluster"
  cluster_version = var.kubernetes_version
  iam_role_name   = "${var.project_id}-${var.environment}-eks-role"

  cluster_endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  # the AWS sandbox does not permit KMS creation
  # create_kms_key = false
  cluster_encryption_config = {}

  create_cloudwatch_log_group = false

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  cluster_addons = {

  }

  access_entries = {
      super-admin = {
        principal_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/dst-admin"

        policy_associations = {
          this = {
            policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
            access_scope = {
              type       = "cluster"
            }
          }
        }
      }     
      deployment = {
        principal_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.project_id}-${var.environment}-github-deployment-role"

        policy_associations = {
          this = {
            policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
            access_scope = {
              type       = "cluster"
            }
          }
        }
      }      
    }

  node_security_group_tags = {
      # NOTE - if creating multiple security groups with this module, only tag the
      # security group that Karpenter should utilize with the following tag
      # (i.e. - at most, only one security group should have this tag in your account)
      "karpenter.sh/discovery" = "${var.project_id}-${var.environment}-cluster"
    }

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# resource "aws_iam_role" "eks_cluster_role" {
#   name = "${var.project_id}-${var.environment}-eks-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Principal = {
#           Service = "eks.amazonaws.com"
#         },
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })

#   tags = {
#     Environment = var.environment
#     Project     = var.project_name
#   }
# }

# resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
#   role       = aws_iam_role.eks_cluster_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
# }

# resource "aws_iam_role_policy_attachment" "eks_service_policy" {
#   role       = aws_iam_role.eks_cluster_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
# }


# data "aws_eks_cluster" "cluster" {
#   name = module.eks.cluster_name
# }

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}


# the module will do this for us
# data "tls_certificate" "cluster" {
#   url = module.eks.cluster_oidc_issuer_url
# }

# resource "aws_iam_openid_connect_provider" "oidc_provider" {
#   client_id_list  = ["sts.amazonaws.com"]
#   thumbprint_list = [data.tls_certificate.cluster.certificates.0.sha1_fingerprint]
#   url             = module.eks.cluster_oidc_issuer_url
# }

# module "lb_role" {
#   source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

#   role_name                              = "${var.project_id}-${var.environment}-eks-alb-role"
#   attach_load_balancer_controller_policy = true

#   oidc_providers = {
#     main = {
#       provider_arn               = module.eks.oidc_provider
#       namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
#     }
#   }
# }
