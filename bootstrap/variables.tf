variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "github_repo" {
  description = "GitHub repository in the format 'org/repo'"
  type        = string
}

variable "environments" {
  type        = list(string)
  description = "List of environments to configure policies for"
}

variable "branches" {
  type    = list(string)
  default = ["develop", "release", "main"]
}

variable "terraform_state_bucket" {
  type        = string
  description = "Name of the S3 bucket to store the terraform state"
}

variable "terraform_locks_table" {
  type        = string
  description = "Name of the DynamoDB table to store the terraform state locks"
}

variable "project_id" {
  type        = string
  description = "Identifier for the current project"
}

variable "project_name" {
  type        = string
  description = "Name of the current project"
}
