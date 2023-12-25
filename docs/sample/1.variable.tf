/*
variable type: string
*/

variable "image_id" {
  type = string
}


/*
variable type: list of string
*/

variable "availability_zone_names" {
  type    = list(string)
  default = ["us-west-1a"]
}


/*
variable type: list of object(dictionary)
*/

variable "docker_ports" {
  type = list(object({
    internal = number
    external = number
    protocol = string
  }))
  default = [
    {
      internal = 8300
      external = 8300
      protocol = "tcp"
    }
  ]
}

/*
Validation
Type: Null Validation
Description: String variable is not null
*/

variable "example" {
  type     = string
  nullable = false
}



/*
Validation - Custom Validation using expression
Description: 
    Validate image_id value to be more than 4 and It should start with ami-
    variable block should have validation block with condition(expression) and error message
*/

variable "image_id" {
  type        = string
  description = "The id of the machine image (AMI) to use for the server."

  validation {
    condition     = length(var.image_id) > 4 && substr(var.image_id, 0, 4) == "ami-"
    error_message = "The image_id value must be a valid AMI id, starting with \"ami-\"."
  }
}

/*
Handline Sensitive Variables
*/

variable "user_information" {
  type = object({
    name    = string
    address = string
  })
  sensitive = true
}


/*
Using Variables in Resources block
*/

resource "some_resource" "a" {
  name    = var.user_information.name
  address = var.user_information.address
}



