variable "aws-region" {
  description = "aws region"
  type        = string
  default     = "us-east-2"
}

variable "google-region" {
  description = "aws region"
  type        = string
  default     = "us-central1"
}

variable "ami-id" {
  description = "The AMI ID for the AWS instance"
  type        = string
  #default     = "ami-05803413c51f242b7" # when default is provided , type is optional
}

variable "instance-type" {
  description = "The instance type for the AWS instance"
  type        = string
  default     = "t2.micro"
}
/*
variable "instance-tags" {
  description = "Tags for the AWS instance"
  type        = map(string)
  default = {
    Name = "treasury-web-app-dev"
  }
}*/

variable "environment" {
  description = "Environment for the resource provisioning"
  type = string
}


