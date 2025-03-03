resource "aws_iam_policy" "s3_trust_policy" {
  name = "${var.project_id}-${var.environment}-eks-s3-policy"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject"
            ],
            "Resource": "arn:aws:s3:::dst-dev-test-bucket/*"
        }
    ]
})
}

resource "aws_iam_role" "s3_role" {
  name = "${var.project_id}-${var.environment}-eks-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "eks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Environment = var.environment,
    Project     = var.project_name,
  }
}

resource "aws_iam_role_policy_attachment" "s3_policy" {
  role       = aws_iam_role.s3_role.name
  policy_arn = aws_iam_policy.s3_trust_policy.arn
}
