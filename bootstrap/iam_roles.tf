locals {
  # List the environments you want to support
  environments = ["dev", "staging", "prod"]
}

resource "aws_iam_role" "github_actions_role" {
  for_each = toset(local.environments)

  name = "${each.key}-deploy-role"

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
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_repo}:ref:refs/heads/${each.key}"
          }
        }
      }
    ]
  })
}
