provider "aws" {
  region = "us-west-2"
}

data "aws_canonical_user_id" "current" {}

resource "aws_s3_bucket" "test-gis-bucket" {
  bucket        = "gfee-gis-reverse-proxy-poc"
  force_destroy = true

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

resource "aws_s3_bucket_acl" "my_bucket_acl" {
  bucket = aws_s3_bucket.test-gis-bucket.id

  access_control_policy {
    owner {
      id = data.aws_canonical_user_id.current.id
    }

    grant {
      permission = "READ"
      grantee {
        type = "Group"
        uri  = "http://acs.amazonaws.com/groups/global/AllUsers"
      }
    }

    grant {
      permission = "WRITE"
      grantee {
        type = "Group"
        uri  = "http://acs.amazonaws.com/groups/global/AllUsers"
      }
    }

  }

}

