provider "aws" {
  region = var.region   # Source bucket region
}

# Source bucket with versioning and replication configuration
resource "aws_s3_bucket" "source_bucket" {
  bucket = var.state_bucket   # Replace with your specific bucket name

  versioning {
    enabled = true
  }

  replication_configuration {
    role = aws_iam_role.replication.arn

    rules {
      id     = "replicate-all"
      status = "Enabled"

      filter {
        prefix = ""
      }

      destination {
        # Note: When specifying the destination bucket, you must reference its ARN.
        bucket        = aws_s3_bucket.replica_bucket.arn
        storage_class = "STANDARD"  # or another storage class if required
      }
    }
  }
}

# Destination bucket in another region for replication
provider "aws" {
  alias  = "dest"
  region = var.backup_region   # Destination bucket region
}

resource "aws_s3_bucket" "replica_bucket" {
  provider = aws.dest

  bucket = "${var.state_bucket}-backup"  # Unique name for the replica bucket

  versioning {
    enabled = true
  }
}

# IAM Role for replication with trust policy for S3
resource "aws_iam_role" "replication" {
  name = "${var.project_id}-${var.environment}-s3-replication-role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAM Policy to allow replication actions
resource "aws_iam_policy" "replication_policy" {
  name   = "s3-replication-policy"
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "s3:GetReplicationConfiguration",
          "s3:ListBucket"
        ]
        Resource = aws_s3_bucket.source_bucket.arn
      },
      {
        Effect   = "Allow"
        Action   = [
          "s3:GetObjectVersion",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectLegalHold",
          "s3:GetObjectRetention",
          "s3:GetObjectTagging",
          "s3:GetObjectVersionTagging"
        ]
        Resource = "${aws_s3_bucket.source_bucket.arn}/*"
      },
      {
        Effect   = "Allow"
        Action   = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ]
        Resource = "${aws_s3_bucket.replica_bucket.arn}/*"
      }
    ]
  })
}

# Attach the IAM policy to the replication role
resource "aws_iam_role_policy_attachment" "replication_attach" {
  role       = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication_policy.arn
}
