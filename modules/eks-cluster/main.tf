module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name    = "${var.project_id}-${var.environment}-cluster"
  cluster_version = var.kubernetes_version

  cluster_endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  access_entries = {
      # One access entry with a policy associated
      example = {
        principal_arn = "arn:aws:iam::123456789012:role/something"

        policy_associations = {
          example = {
            policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
            access_scope = {
              namespaces = ["default"]
              type       = "namespace"
            }
          }
        }
      }
    }

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.project_id}-${var.environment}-eks-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}



# Retrieve the EKS cluster details
data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.this.name
}

# output "eks_cluster_identity" {
#   value = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
# }

# data "aws_iam_openid_connect_provider" "eks_oidc" {
#   url = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
# }


data "tls_certificate" "cluster" {
  url = data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer
}

resource "aws_iam_openid_connect_provider" "oidc_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster.certificates.0.sha1_fingerprint]
  url             = data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer
}

# data "aws_eks_cluster" "cluster" {
#   name = var.cluster_name
# }

data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.this.name
}

# resource "aws_eks_access_entry" "example" {
#   cluster_name      = aws_eks_cluster.this.name
#   principal_arn     = "arn:aws:iam::707809188586:user/dst-github"
#   kubernetes_groups = ["system:masters"]
#   type              = "STANDARD"
# }



# # Fetch the AWS Load Balancer Controller IAM policy JSON from GitHub
# data "http" "alb_policy" {
#   url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.11.0/docs/install/iam_policy.json"
# }

# # Create the IAM policy for the AWS Load Balancer Controller
# resource "aws_iam_policy" "aws_load_balancer_controller_policy" {
#   name        = "${var.project_id}-${var.environment}-alb-controller-policy-2"
#   description = "IAM policy for AWS Load Balancer Controller"
#   policy      = data.http.alb_policy.response_body
# }

# output "policy-document" {
#   value = aws_iam_policy.aws_load_balancer_controller_policy
# }

# # Create an IAM role for the AWS Load Balancer Controller with IRSA trust policy
# resource "aws_iam_role" "aws_load_balancer_controller_role" {
#   name = "${var.project_id}-${var.environment}-alb-controller-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect    = "Allow",
#         Principal = {
#           Federated = data.aws_iam_openid_connect_provider.eks_oidc.arn
#         },
#         Action = "sts:AssumeRoleWithWebIdentity",
#         Condition = {
#           StringEquals = {
#             # Use the issuer URL from the cluster identity for the condition key.
#             "${data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
#           }
#         }
#       }
#     ]
#   })
# }

# # Attach the policy to the role
# resource "aws_iam_role_policy_attachment" "alb_controller_policy_attachment" {
#   role       = aws_iam_role.aws_load_balancer_controller_role.name
#   policy_arn = aws_iam_policy.aws_load_balancer_controller_policy.arn
# }

# output "aws_load_balancer_controller_role_arn" {
#   value = aws_iam_role.aws_load_balancer_controller_role.arn
# }