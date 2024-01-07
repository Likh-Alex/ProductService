terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.31.0"
    }
  }
  backend "remote" {
    organization = "product_service_demo"

    workspaces {
      name = "ProductService"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}
