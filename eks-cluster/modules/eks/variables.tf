variable "cluster_name" {
  type        = string
}

# variable "vpc" {
#   description = "The VPC"
#   type        = string
# }

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "private_subnets" {
  description = "The subnet IDs"
  type        = list(string)
}

variable "environment" {
  type = string
}