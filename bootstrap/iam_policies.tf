resource "aws_iam_policy" "github_actions_policy" {
  for_each = toset(local.environments)

  name        = "dst-${each.key}-deploy-policy"
  description = "Policy for GitHub Actions deployment in ${each.key}"

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "s3:PutObject",
          "s3:GetObject",
          "ec2:DescribeInstances"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_actions_attachment" {
  for_each = toset(local.environments)

  role       = aws_iam_role.github_actions_role[each.key].name
  policy_arn = aws_iam_policy.github_actions_policy[each.key].arn
}
