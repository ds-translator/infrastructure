variable "region" {
  description = "The AWS region"
  type        = string
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

variable "backup_region" {
    type = string
}

variable "state_bucket" {
    type = string
}