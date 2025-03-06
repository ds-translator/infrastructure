provider "aws" {
  region = var.region
}

resource "aws_iam_role" "node_group_role" {
  name = "${var.project_id}-${var.environment}-eks-ng-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Environment = var.environment,
    Project     = var.project_name,
  }
}



# Attach the AmazonEKSWorkerNodePolicy to allow necessary EKS worker node actions.
resource "aws_iam_role_policy_attachment" "node_worker_policy" {
  role       = aws_iam_role.node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

# Attach the AmazonEKS_CNI_Policy for networking functionality.
resource "aws_iam_role_policy_attachment" "node_cni_policy" {
  role       = aws_iam_role.node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# Attach the AmazonEC2ContainerRegistryReadOnly policy for pulling container images.
resource "aws_iam_role_policy_attachment" "node_registry_policy" {
  role       = aws_iam_role.node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Attach the CloudWatchAgentServerPolicy for sending to CloudWatch
resource "aws_iam_role_policy_attachment" "node_cloud_watch_policy" {
  role       = aws_iam_role.node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_policy" "node_s3_policy" {
  name = "${var.project_id}-${var.environment}-eks-node-s3-policy"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::dst-dev-test-bucket"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject"
            ],
            "Resource": "arn:aws:s3:::dst-dev-test-bucket/*"
        }
    ]
})
}

# Attach the S3 policy to allow access to S3.
resource "aws_iam_role_policy_attachment" "node_s3_policy" {
  role       = aws_iam_role.node_group_role.name
  policy_arn = aws_iam_policy.node_s3_policy.arn
}

# Attach the AmazonEBSCSIDriverPolicy policy for accessing EBS.
resource "aws_iam_role_policy_attachment" "node_ebs_policy" {
  role       = aws_iam_role.node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

