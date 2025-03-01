output "lb_role_arn" {
  description = "The name of the created EKS cluster."
  value       = module.lb_role.iam_role_arn
}
