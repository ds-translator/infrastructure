variable "cluster_name" {
  type        = string
}

variable "vpc" {
  description = "The VPC"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "The subnet IDs"
  type        = string
}