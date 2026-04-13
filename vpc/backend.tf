terraform {
  backend "s3" {
    bucket = "mza-terraform-states"
    key = "vpc/terraform.tfstate"
    region = "us-east-2"
    encrypt = true
  }
}