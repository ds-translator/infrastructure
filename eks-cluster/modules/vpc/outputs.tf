# output "vpc_id" {
#   value = aws_vpc.main.id
#   description = "The ID of the VPC"
# }

# output "subnet_ids" {
#   value = aws_subnet.subnets.*.id
#   description = "List of subnet IDs"
# }

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

# output "private_subnets_ids" {
#   value = aws_subnet.subnets.*.id
#   description = "List of subnet IDs"
# }

output "public_subnets" {
  value = module.vpc.public_subnets
}
