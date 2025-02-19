# variable "cluster_name" {
#   description = "The name of the EKS cluster."
#   type        = string
# }

# variable "cluster_role_arn" {
#   description = "The ARN of the IAM role that EKS uses to manage cluster resources."
#   type        = string
# }

variable "vpc_id" {
  description = "The ID of the VPC to use."
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs where the EKS cluster will run."
  type        = list(string)
}

variable "kubernetes_version" {
  description = "The Kubernetes version for the EKS cluster."
  type        = string
  default     = "1.31"  # Adjust as needed
}

variable "environment" {
  description = "The environment (dev, stage, prod, etc.) for tagging."
  type        = string
}

variable "project_name" {
    type = string
}

variable "project_id" {
    type = string
}