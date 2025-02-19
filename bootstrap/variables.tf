variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "github_repo" {
  description = "GitHub repository in the format 'org/repo'"
  type        = string
  default     = "ds-translator/infrastructure"
}
