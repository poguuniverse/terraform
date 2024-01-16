variable "ami_name" {
  type = string
}

variable "key-name" {
  type = string
  default = "example-key"
}


variable "ingress_ports" {
  type = list(string)
}

variable "egress_ports" {
  type = list(string)
}

variable "instance_metadata" {
  description = "Metadata for different instances"
  type = map(object({
    hostname      = string
    instance_type = string
  }))
}


variable "app_name" {
  type = "string"
}
