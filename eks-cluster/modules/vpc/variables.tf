variable "project_name" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "environment" {
  type = string
}

variable "name" {
  type = string
}

variable "cidr" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}
