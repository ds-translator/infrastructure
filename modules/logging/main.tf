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

resource "aws_iam_role" "eks_service_account" {
  name               = "${var.project_id}-${var.environment}-eks-service-account-role"
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role_policy.json
}

resource "aws_iam_role_policy" "cloudwatch_logging" {
  name   = "${var.project_id}-${var.environment}-eks-cloud-watch-logging-role"
  role   = aws_iam_role.eks_service_account.name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "CloudWatchLogging",
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "kubernetes_service_account" "cloudwatch_agent" {
  metadata {
    name      = "cloudwatch-agent"
    namespace = var.environment
    labels = {
      "app.kubernetes.io/name"      = "cloudwatch-agent"
      "app.kubernetes.io/component" = "agent"
    }

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.eks_service_account.arn
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }
}

