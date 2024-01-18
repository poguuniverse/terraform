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

  validation {
    condition     = can(index(["t2.micro", "t3.micro", "t3.small"], var.instance-type) >= 0)
    error_message = "Invalid instance type. It must be 't2.micro', 't3.micro', or 't3.small'."
  }
}

variable "environment" {
  description = "Environment for the resource provisioning"
  type = string

  validation {
    condition     = can(regex("^(dev|prod|staging)$", var.environment))
    error_message = "Invalid environment. It must be 'dev', 'prod', or 'staging'."
  }
}

variable "backend_subnet_count" {
  description = "Number of subnets for backend"
  type        = number
  default     = 2
}

variable "webapp_subnet_count" {
  description = "Number of webapp subnets."
  type        = number
  default     = 2
}

variable "backend_subnet_cidr_blocks" {
  description = "Available cidr blocks for backend subnets."
  type        = list(string)
  default     = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
    "10.0.4.0/24",
    "10.0.5.0/24",
    "10.0.6.0/24",
    "10.0.7.0/24",
    "10.0.8.0/24",
  ]
}

variable "webapp_subnet_cidr_blocks" {
  description = "Available cidr blocks for webapp subnets."
  type        = list(string)
  default     = [
    "10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24",
    "10.0.104.0/24",
    "10.0.105.0/24",
    "10.0.106.0/24",
    "10.0.107.0/24",
    "10.0.108.0/24",
  ]
}

# Variables
variable "create_backend_instance" {
  description = "Whether to create the backend EC2 instance"
  type        = bool
  default     = true
}

variable "backend_instance_ami" {
  description = "The AMI ID for the backend EC2 instance"
  type        = string
  default     = "ami-05803413c51f242b7"
}

variable "backend_instance_type" {
  description = "The instance type for the backend EC2 instance"
  type        = string
  default     = "t2.micro"
}

###############

variable "frontend_instance_config" {
  description = "Configuration for the frontend instance"
  type        = object({
    backend_ip          = string
    backend_port        = number
    backend_service_name = string
  })
  default = {
    backend_ip          = "10.0.1.10"
    backend_port        = 8080
    backend_service_name = "backend-service"
  }
}

variable "backend_instance_config" {
  description = "Configuration for the backend instance"
  type        = object({
    db_name        = string
    db_port        = number
  })
  default = {
    db_name        = "mydatabase"
    db_port        = 3306
  }
}

variable "allowed_additional_backend_ports" {
  description = "map of allowed backend ports"
  type        = map(number)
  default     = {
    port_8080 = 8080
    port_8081 = 8081
    port_8082 = 8082
  }
}

# main.tf

# Variables
variable "sns_topics" {
  description = "Map of AWS SNS topics to create"
  type        = map(string)
  default = {
    backend_notifications = "Backend Notifications"
    webapp_alerts      = "Development Alerts"
  }
}







