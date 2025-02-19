data "aws_caller_identity" "current" {}

resource "aws_iam_policy" "github_actions_infrastructure_policy" {
  for_each = toset(var.environments)

  name        = "${var.project_id}-${each.key}-github-infrastructure-policy"
  description = "Policy for GitHub Actions infrastructure provisioning in ${each.key}"

  policy = templatefile(
    "${path.module}/policies/dst-${each.key}-terraform-least-privilege.json",
    {
      aws_caller_identity    = data.aws_caller_identity.current.account_id
      environment            = each.key
      aws_region             = var.aws_region
      terraform_state_bucket = var.terraform_state_bucket
      terraform_locks_table  = var.terraform_locks_table
      project_id             = var.project_id
    }
  )
  tags = {
    Environment = each.key
    Project     = var.project_name
    Terraform   = true
  }  
}

resource "aws_iam_role_policy_attachment" "github_actions_infrastructure_attachment" {
  for_each = toset(var.environments)

  role       = aws_iam_role.github_actions_infrastructure_role[each.key].name
  policy_arn = aws_iam_policy.github_actions_infrastructure_policy[each.key].arn
}
