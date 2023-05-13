provider "aws" {
  region = "us-west-2"
}

data "aws_canonical_user_id" "current" {}

resource "aws_s3_bucket" "test-gis-bucket" {
  bucket        = "gfee-gis-reverse-proxy-poc"
  force_destroy = true
  # acl           = "private"

  tags = {
    Name        = "terraform gis proxy poc"
    Environment = "dev"
  }

}

resource "aws_s3_bucket_lifecycle_configuration" "auto-clean-1-day" {
  bucket = aws_s3_bucket.test-gis-bucket.id
  rule {
    id     = "auto-delete-rule-1"
    status = "Enabled"

    expiration {
      days = 1
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "acl_ownership_controls" {
  bucket = aws_s3_bucket.test-gis-bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "private_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.acl_ownership_controls]
  bucket     = aws_s3_bucket.test-gis-bucket.id
  acl        = "private"
}