## Bucket creation
resource "aws_s3_bucket" "state_bucket" {
  bucket = "tf-state-platform-engineering-bucket"

  tags = {
    Name        = "tf-state-bucket"
    Environment = "prod"
  }
}

## bucket versioning

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.state_bucket.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

## life-cycle policy

resource "aws_s3_bucket_lifecycle_configuration" "state_bucket" {
  bucket = aws_s3_bucket.state_bucket.bucket

  rule {
    id = "delete-old-state-files"
    
    noncurrent_version_expiration {
      noncurrent_days = 90
    }

    status = "Enabled"
  }
}

## Enable server-side-encryption

resource "aws_s3_bucket_server_side_encryption_configuration" "state_bucket" {
  bucket = aws_s3_bucket.state_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

## block public access

resource "aws_s3_bucket_public_access_block" "state_bucket" {
  bucket = aws_s3_bucket.state_bucket.bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}