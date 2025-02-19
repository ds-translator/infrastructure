output "oidc_provider_arn" {
  description = "The ARN of the GitHub OIDC provider"
  value       = aws_iam_openid_connect_provider.github.arn
}

output "infrastructure_roles" {
  description = "ARNs of the infrastructure roles by environment"
  value       = { for env, role in aws_iam_role.github_actions_infrastructure_role : env => role.arn }
}

output "infrastructure_policies" {
  description = "ARNs of the infrastructure policies by environment"
  value       = { for env, policy in aws_iam_policy.github_actions_infrastructure_policy : env => policy.arn }
}

output "deployment_roles" {
  description = "ARNs of the deployment roles by environment"
  value       = { for env, role in aws_iam_role.github_actions_deployment_role : env => role.arn }
}

# output "deployment_policies" {
#   description = "ARNs of the deployment policies by environment"
#   value       = { for env, policy in aws_iam_policy.github_actions_deployment_policy : env => policy.arn }
# }
