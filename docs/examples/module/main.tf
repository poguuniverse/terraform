
terraform {
  required_providers {
    aws ={
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
}


provider "aws" {
    region = var.region
}

module "app-vpc"{
    source = "../modules/aws/network/vpc"
    region = var.region
    cidr = "10.0.0.0/16"
}