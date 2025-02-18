data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  value = var.region
}

resource "aws_iam_role" "terraform_execution_role" {
  name = "dst-TerraformExecutionRole"

  # lifecycle {
  #   prevent_destroy = true
  # }

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "terraform_least_privilege_policy" {
  name        = "dst-TerraformLeastPrivilegePolicy"
  description = "Provides only the required permissions for Terraform execution"

  # lifecycle {
  #   prevent_destroy = true
  # }

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Effect": "Allow",
        "Action": [
                "s3:ListBucket",
                "s3:GetBucketVersioning",
                "s3:GetEncryptionConfiguration",
                "s3:GetBucketPolicy",
                "s3:GetBucketPublicAccessBlock"
            ],
        "Resource": [
          "arn:aws:s3:::dst-terraform-state",
          "arn:aws:s3:::dst-terraform-state-*/*"
        ]
      },
      {
        "Action": "s3:CreateBucket",
        "Effect": "Allow",
        "Resource": "*"
      },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:GetObjectVersion"
            ],
            "Resource": "arn:aws:s3:::dst-terraform-state/*"
        },      
      {
        "Effect": "Allow",
        "Action": [
          "dynamodb:DescribeTable",
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:DeleteItem",
          "dynamodb:Scan",
          "dynamodb:Query",
          "dynamodb:UpdateItem"
        ],
        "Resource": "arn:aws:dynamodb:*:${data.aws_caller_identity.current.account_id}:table/dst-terraform-locks"
      },
        {
            "Effect": "Allow",
            "Action": [
                "sts:GetCallerIdentity",
                "ec2:DescribeAvailabilityZones",
                "iam:GetPolicy",
                "iam:GetPolicyVersion",
                "iam:ListPolicyVersions",
                "iam:DeletePolicyVersion",
                "iam:CreatePolicyVersion"                

            ],
            "Resource": "*"
        },
      {
        "Effect": "Allow",
        "Action": [
          "ec2:DescribeInstances",
          "ec2:RunInstances",
          "ec2:TerminateInstances",
          "ec2:StartInstances",
          "ec2:StopInstances",
          "ec2:DescribeAvailabilityZones"

        ],
        "Resource": "*"
      },

      {
        "Effect": "Allow",
        "Action": [
          "iam:GetRole",
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
          "iam:PassRole"
        ],
        "Resource": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/dst-TerraformExecutionRole"
      },

      {
        "Effect": "Allow",
        "Action": [
          "ec2:DescribeVpcs",
          "ec2:CreateVpc",
          "ec2:DeleteVpc",
          "ec2:DescribeSubnets",
          "ec2:CreateSubnet",
          "ec2:DeleteSubnet",
          "ec2:DescribeSecurityGroups",
          "ec2:CreateSecurityGroup",
          "ec2:DeleteSecurityGroup"
        ],
        "Resource": "*"
      },
        {
            "Effect": "Allow",
            "Action": [
                "iam:GetRole",
                "iam:ListRolePolicies",
                "iam:ListAttachedRolePolicies"
            ],
            "Resource": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:ListAttachedGroupPolicies"
            ],
            "Resource": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:group/*"
        },

      {
        "Effect": "Allow",
        "Action": "sts:AssumeRole",
        "Resource": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/dst-TerraformExecutionRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "terraform_policy_attachment" {
  role       = aws_iam_role.terraform_execution_role.name
  policy_arn = aws_iam_policy.terraform_least_privilege_policy.arn
}


resource "aws_iam_policy" "assume_terraform_role_policy" {
  name        = "dst-AssumeTerraformRolePolicy"
  description = "Allows IAM users in this group to assume TerraformExecutionRole"

  # lifecycle {
  #   prevent_destroy = true
  # }

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow"
      Action   = "sts:AssumeRole"
      Resource = aws_iam_role.terraform_execution_role.arn
    }]
  })
}

resource "aws_iam_group_policy_attachment" "terraform_assume_role_policy" {
  group      = var.group_name
  policy_arn = aws_iam_policy.assume_terraform_role_policy.arn
}

output "terraform_execution_role_arn" {
  value = aws_iam_role.terraform_execution_role.arn
}
