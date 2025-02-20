output "cluster_id" {
  description = "The ID of the created EKS cluster."
  value       = module.eks.cluster_id
}

output "cluster_name" {
  description = "The name of the created EKS cluster."
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "The endpoint for the EKS cluster."
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "The certificate authority data for the cluster."
  value       = module.eks.cluster_certificate_authority_data
}
output "cluster_token" {
  description = "The authentication token for the EKS cluster."
  value       = data.aws_eks_cluster_auth.cluster.token
  sensitive   = true
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}