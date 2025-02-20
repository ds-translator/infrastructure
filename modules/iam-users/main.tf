
# Create IAM Group
resource "aws_iam_group" "group" {
  name = var.group_name
}

# Create IAM Users dynamically
resource "aws_iam_user" "users" {
  for_each = toset(var.users)
  name     = each.value
}

# Add Users to the DevOps Group
resource "aws_iam_group_membership" "group_membership" {
  name  = "${var.group_name}-membership"
  group = aws_iam_group.group.name

  users = [for user in aws_iam_user.users : user.name]
}
