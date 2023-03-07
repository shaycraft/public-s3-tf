provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "test-gis-bucket" {
  bucket = "my-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "dev"
  }

}

resource "aws_s3_bucket_acl" "my_bucket_acl" {
  bucket = aws_s3_bucket.test-gis-bucket.id

  access_control_policy {
    owner {
      id = ""
    }
    grant {
      permission = "READ"
      grantee {
        type = "Group"
        uri  = "http://acs.amazonaws.com/groups/s3/AllUsers"
      }
    }
  }
}

