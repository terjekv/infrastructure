terraform {
  backend "s3" {
    bucket = "eessi-terraform-state"
    key    = "terraform.state"
    region = "eu-west-1"
  }
}