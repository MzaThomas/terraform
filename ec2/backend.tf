terraform {
  backend "s3" {
    bucket = "mza-terraform-states"
    key = "ec2/terraform.tfstate"
    region = "us-east-2"
    encrypt = true
  }
}