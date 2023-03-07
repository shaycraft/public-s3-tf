terraform {
  cloud {
    organization = "mr-gav-meow"

    workspaces {
      name = "public-s3"
    }
  }
}
