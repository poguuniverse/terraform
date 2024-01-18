provider "aws" {
  region = "us-east-2"
}

provider "google" {
  region = "us-central1"
}

resource "aws_instance" "web" {
  ami           = "ami-05803413c51f242b7"
  instance_type = "t2.micro"

  tags = {
    Name = "treasury-web-app-dev"
  }
}

