
# Create IAM Group for DevOps Engineers
resource "aws_iam_group" "devops_engineers" {
  name = "devops-engineers"
}

# Create IAM Users

resource "aws_iam_user" "janod" {
  name = "janod"
}

resource "aws_iam_user" "julian" {
  name = "julian"
}

resource "aws_iam_user" "loay" {
  name = "loay"
}

resource "aws_iam_user" "patrick" {
  name = "patrick"
}

# Add Users to the DevOps Group
resource "aws_iam_group_membership" "devops_group_membership" {
  name  = "devops-engineers-membership"
  group = aws_iam_group.devops_engineers.name

  users = [
    aws_iam_user.janod.name,
    aws_iam_user.julian.name,
    aws_iam_user.loay.name,
    aws_iam_user.patrick.name
  ]
}

# Output Group ARN
output "devops_group_arn" {
  value = aws_iam_group.devops_engineers.arn
}
