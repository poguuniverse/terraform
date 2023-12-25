# Input variable: server port
variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default = "8080"
}

variable "region" {
  description = "AWS Region to create resources"
  type = string
  default = "us-east-1"
}