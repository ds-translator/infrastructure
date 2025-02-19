locals {
  env_branch_map = zipmap(var.environments, var.branches)
}

resource "aws_iam_role" "github_actions_infrastructure_role" {
  for_each = toset(var.environments)

  name = "${var.project_id}-${each.key}-github-infrastructure-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Action    = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com",
            # Adjust this condition as needed to restrict by repository and branch.
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_infrastructure_repo}:ref:refs/heads/${lookup(local.env_branch_map, each.key)}"
          }
        }
      }
    ]
  })

  tags = {
    Environment = each.key
    Project     = var.project_name
    Terraform   = true
  }  
}

resource "aws_iam_role" "github_actions_deployment_role" {
  for_each = toset(var.environments)

  name = "${var.project_id}-${each.key}-github-deployment-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Action    = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com",
            # Adjust this condition as needed to restrict by repository and branch.
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_deployment_repo}:ref:refs/heads/${lookup(local.env_branch_map, each.key)}"
          }
        }
      }
    ]
  })

  tags = {
    Environment = each.key
    Project     = var.project_name
    Terraform   = true
  }  
}