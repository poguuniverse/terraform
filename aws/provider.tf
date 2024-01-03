provider "aws" {
  region = "us-east-2"
}


terraform {
  backend "local" {
    path = "statefile.tfstate"
  }
}
