output "oidc_provider_arn" {
  description = "The ARN of the GitHub OIDC provider"
  value       = aws_iam_openid_connect_provider.github.arn
}

output "deploy_roles" {
  description = "ARNs of the deployment roles by environment"
  value       = { for env, role in aws_iam_role.github_actions_role : env => role.arn }
}

output "deploy_policies" {
  description = "ARNs of the deployment policies by environment"
  value       = { for env, policy in aws_iam_policy.github_actions_policy : env => policy.arn }
}
