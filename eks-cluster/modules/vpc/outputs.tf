output "vpc_id" {
  value = aws_vpc.main.id
  description = "The ID of the VPC"
}

output "subnet_ids" {
  value = aws_subnet.subnets.*.id
  description = "List of subnet IDs"
}
