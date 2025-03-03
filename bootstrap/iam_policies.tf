data "aws_caller_identity" "current" {}

resource "aws_iam_policy" "github_actions_infrastructure_base_policy" {
  for_each = toset(var.environments)

  name        = "${var.project_id}-${each.key}-github-infrastructure-base-policy"
  description = "Policy for GitHub Actions infrastructure provisioning in ${each.key}"

  policy = templatefile(
    "${path.module}/policies/dst-${each.key}-terraform-base-least-privilege.json",
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

resource "aws_iam_policy" "github_actions_infrastructure_eks_policy" {
  for_each = toset(var.environments)

  name        = "${var.project_id}-${each.key}-github-infrastructure-eks-policy"
  description = "Policy for GitHub Actions infrastructure EKS provisioning in ${each.key}"

  policy = templatefile(
    "${path.module}/policies/dst-${each.key}-terraform-eks-least-privilege.json",
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

# Attach the base policy to the infrastructure role
resource "aws_iam_role_policy_attachment" "github_actions_infrastructure_base_attachment" {
  for_each = toset(var.environments)

  role       = aws_iam_role.github_actions_infrastructure_role[each.key].name
  policy_arn = aws_iam_policy.github_actions_infrastructure_base_policy[each.key].arn
}

# Attach the EKS policy to the infrastructure role
resource "aws_iam_role_policy_attachment" "github_actions_infrastructure_eks_attachment" {
  for_each = toset(var.environments)

  role       = aws_iam_role.github_actions_infrastructure_role[each.key].name
  policy_arn = aws_iam_policy.github_actions_infrastructure_eks_policy[each.key].arn
}

resource "aws_iam_policy" "github_actions_deployment_policy" {
  for_each = toset(var.environments)

  name        = "${var.project_id}-${each.key}-github-deployment-policy"
  description = "Policy for GitHub Actions deployment in ${each.key}"

  policy = templatefile(
    "${path.module}/policies/dst-${each.key}-deployment-least-privilege.json",
    {
      aws_caller_identity    = data.aws_caller_identity.current.account_id
      environment            = each.key
      aws_region             = var.aws_region
      project_id             = var.project_id
    }
  )
  tags = {
    Environment = each.key
    Project     = var.project_name
    Terraform   = true
  }  
}

resource "aws_iam_role_policy_attachment" "github_actions_deployment_attachment" {
  for_each = toset(var.environments)

  role       = aws_iam_role.github_actions_deployment_role[each.key].name
  policy_arn = aws_iam_policy.github_actions_deployment_policy[each.key].arn
}