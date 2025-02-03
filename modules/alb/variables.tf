variable "project_name" {
    type = string
}

variable "project_id" {
    type = string
}

variable "environment" {
    type = string
}

variable "vpc_id" {
  description = "The VPC in which to create the ALB."
  type        = string
}

variable "subnets" {
  description = "A list of subnets in which to deploy the ALB."
  type        = list(string)
}

# variable "security_groups" {
#   description = "A list of security groups to attach to the ALB."
#   type        = list(string)
# }

variable "listener_port" {
  description = "The port on which the ALB will listen."
  type        = number
  default     = 80
}

variable "listener_protocol" {
  description = "The protocol for the ALB listener."
  type        = string
  default     = "HTTP"
}

variable "target_port" {
  description = "The port on which the target instances are listening."
  type        = number
  default     = 80
}

variable "target_protocol" {
  description = "The protocol for communication between the ALB and its targets."
  type        = string
  default     = "HTTP"
}

variable "health_check_path" {
  description = "The URL path on which to perform health checks on the targets."
  type        = string
  default     = "/"
}
