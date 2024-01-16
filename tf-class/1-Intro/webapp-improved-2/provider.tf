terraform {
  required_providers {
    aws = {
      version = "~> 5.30.0"
    }
    google = {
      version = ">= 5.11.0"
    }
  }

  required_version = "~> 1.6.6" #terraform-cli version
}

provider "aws" {
  # region = "us-east-2"
  region = var.aws-region
}

provider "google" {
  # region = "us-central1"
  region = var.google-region
}

