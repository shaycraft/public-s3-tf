provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "dev"
  }

}

resource "aws_s3_bucket_acl" "my_bucket_acl" {
  bucket = aws_s3_bucket.my_bucket.id

  grants {
    permission = "READ"
    type       = "Group"
    uri        = "http://acs.amazonaws.com/groups/global/AllUsers"
  }
}

