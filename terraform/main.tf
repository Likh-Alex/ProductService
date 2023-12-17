terraform {
  backend "s3" {
    bucket = "product-service-terraform-state"
    key    = "terraform/state/terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = "eu-central-1"
}
