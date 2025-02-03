output "node_role_name" {
  description = "The name of the EKS node group IAM role"
  value       = aws_iam_role.node_group_role.name
}

output "node_role_arn" {
  description = "The ARN of the EKS node group IAM role"
  value       = aws_iam_role.node_group_role.arn
}