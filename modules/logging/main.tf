output "oidc_provider_url" {
  value = var.oidc_provider_url
}

output "oidc_provider_arn" {
  value = var.oidc_provider_arn
}

# data "aws_eks_cluster_auth" "eks_cluster_auth" {
#   name = var.cluster_name
# }

# provider "kubernetes" {
#   host                   = var.cluster_endpoint
#   cluster_ca_certificate = base64decode(var.cluster_certificate_authority_data)
#   token                  = data.aws_eks_cluster_auth.eks_cluster_auth.token
# }

data "aws_iam_policy_document" "eks_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_provider_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.environment}:cloudwatch-agent"]
    }
  }
}

# resource "aws_iam_role" "eks_service_account" {
#   name               = "${var.project_id}-${var.environment}-eks-service-account-role"
#   assume_role_policy = data.aws_iam_policy_document.eks_assume_role_policy.json
# }

# resource "aws_iam_role_policy" "cloudwatch_logging" {
#   name   = "${var.project_id}-${var.environment}-eks-cloud-watch-logging-policy"
#   role   = aws_iam_role.eks_service_account.name
#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Sid    = "CloudWatchLogging",
#         Effect = "Allow",
#         Action = [
#           "logs:CreateLogGroup",
#           "logs:CreateLogStream",
#           "logs:PutLogEvents"
#         ],
#         Resource = "*"
#       }
#     ]
#   })
# }

# resource "kubernetes_service_account" "cloudwatch_agent" {
#   metadata {
#     name      = "cloudwatch-agent"
#     namespace = var.environment

#     annotations = {
#       "eks.amazonaws.com/role-arn" = aws_iam_role.eks_service_account.arn
#     }
#   }
# }

