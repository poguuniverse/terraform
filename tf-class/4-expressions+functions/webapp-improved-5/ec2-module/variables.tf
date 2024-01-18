# modules/common_resources/main.tf

variable "tag_prefix_name" {
  description = "Prefix name for resource tags"
  type        = string
}

variable "environment" {
  description = "Environment for the resources"
  type        = string
}
variable "vpc_id" {
  description = "vpc for the resources"
  type        = string
}
variable "ami_id" {
  type        = string
}

variable "instance_type" {
  type        = string
}

variable "subnet_id" {
  type        = string
}

variable "user-data" {
  type = string
}

variable "public-key" {
  type = string
}

variable "allowed_ports" {
  description = "List of allowed ports for security group rules"
  type        = map(number)
}