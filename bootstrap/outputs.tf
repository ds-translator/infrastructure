output "oidc_provider_arn" {
  description = "The ARN of the GitHub OIDC provider"
  value       = aws_iam_openid_connect_provider.github.arn
}

output "infrastructure_roles" {
  description = "ARNs of the infrastructure roles by environment"
  value       = { for env, role in aws_iam_role.github_actions_infrastructure_role : env => role.arn }
}

output "infrastructure_base_policies" {
  description = "ARNs of the infrastructure base policies by environment"
  value       = { for env, policy in aws_iam_policy.github_actions_infrastructure_base_policy : env => policy.arn }
}

output "infrastructure_eks_policies" {
  description = "ARNs of the infrastructure EKS policies by environment"
  value       = { for env, policy in aws_iam_policy.github_actions_infrastructure_eks_policy : env => policy.arn }
}

output "deployment_roles" {
  description = "ARNs of the deployment roles by environment"
  value       = { for env, role in aws_iam_role.github_actions_deployment_role : env => role.arn }
}

# output "deployment_policies" {
#   description = "ARNs of the deployment policies by environment"
#   value       = { for env, policy in aws_iam_policy.github_actions_deployment_policy : env => policy.arn }
# }

output "nameservers" {
  value       = aws_route53_zone.dst_hosted_zone.name_servers
  description = "The list of nameservers for the hosted zone"
}