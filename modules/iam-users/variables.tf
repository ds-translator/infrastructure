variable "group_name" {
  description = "The name of the IAM group"
  type        = string
}

variable "users" {
  description = "List of IAM users to create"
  type        = list(string)
}
