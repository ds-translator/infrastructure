variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "node_count" {
  description = "Number of EKS worker nodes"
  type        = number
}

variable "cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)
}
