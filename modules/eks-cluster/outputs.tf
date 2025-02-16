output "cluster_id" {
  description = "The ID of the created EKS cluster."
  value       = aws_eks_cluster.this.id
}

output "cluster_name" {
  description = "The name of the created EKS cluster."
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "The endpoint for the EKS cluster."
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority_data" {
  description = "The certificate authority data for the cluster."
  value       = aws_eks_cluster.this.certificate_authority.0.data
}
output "cluster_token" {
  description = "The authentication token for the EKS cluster."
  value       = data.aws_eks_cluster_auth.cluster.token
  sensitive   = true
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.oidc_provider.arn
}