
variable "gcp_projectid" {
  type = string
}

variable "gcp_region" {
  type    = string
  default = "us-central1"
}

variable "gcp_zone" {
  type    = string
  default = "us-central1-a"
}

variable "service_account_id" {
  type = string
}

variable "service_account_name" {
  type = string
}

variable "iam_role" {
  type = list(string)
  default = [ "roles/editor" ]
}

