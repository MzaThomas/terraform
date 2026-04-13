data "terraform_remote_state" "vpc" {
    backend = "s3"

    config = {
      bucket = "mza-terraform-states"
      key = "vpc/terraform.tfstate"
      region = "us-east-2"
    }
}