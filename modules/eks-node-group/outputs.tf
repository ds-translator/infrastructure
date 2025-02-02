output "node_group_id" {
  description = "The ID of the EKS node group."
  value       = aws_eks_node_group.this.id
}

output "node_group_arn" {
  description = "The ARN of the EKS node group."
  value       = aws_eks_node_group.this.arn
}
