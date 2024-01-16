provider "aws" {
  region = "us-east-2"
}


terraform {
/*  backend "local" {
    path = "statefile.tfstate"
  }*/
  backend "s3" {
    bucket         = "insurance-claims-app"
    key            = "terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "tf-backend"
  }
}
