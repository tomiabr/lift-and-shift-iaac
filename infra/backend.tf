terraform {
  backend "s3" {
    bucket = "terra-state-backend33"
    key    = "terraform/backend"
    region = "us-east-1"
  }
}