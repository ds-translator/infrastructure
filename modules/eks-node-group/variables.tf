variable "cluster_name" {
  description = "The name of the EKS cluster to attach the node group to."
  type        = string
}

variable "node_group_name" {
  description = "The name of the EKS node group."
  type        = string
}

variable "node_role_arn" {
  description = "The ARN of the IAM role for the node group."
  type        = string
}

variable "subnet_ids" {
  description = "The list of subnet IDs for the node group."
  type        = list(string)
}

variable "desired_size" {
  description = "The desired number of nodes."
  type        = number
  default     = 2
}

variable "min_size" {
  description = "The minimum number of nodes."
  type        = number
  default     = 1
}

variable "max_size" {
  description = "The maximum number of nodes."
  type        = number
  default     = 3
}

variable "instance_types" {
  description = "List of instance types for the node group."
  type        = list(string)
  default     = ["t3.medium"]
}

variable "disk_size" {
  description = "Disk size (in GiB) for the worker nodes."
  type        = number
  default     = 20
}

variable "ec2_ssh_key" {
  description = "Name of an existing EC2 KeyPair to enable SSH access to the nodes. Leave empty if not used."
  type        = string
  default     = ""
}

variable "source_security_group_ids" {
  description = "List of security group IDs to allow SSH access to the nodes. Leave empty if not used."
  type        = list(string)
  default     = []
}

variable "max_unavailable" {
  description = "Maximum number of nodes that can be unavailable during an update."
  type        = number
  default     = 1
}

variable "environment" {
  description = "The environment (e.g., dev, stage, prod) for tagging purposes."
  type        = string
}

variable "project_name" {
  description = "The project name for tagging purposes."
  type        = string
}

variable "project_id" {
  description = "The project name for tagging purposes."
  type        = string
}


variable "extra_tags" {
  description = "Additional tags to apply to the node group."
  type        = map(string)
  default     = {}
}
