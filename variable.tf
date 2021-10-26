
variable "image_id" {
  default = "ami-090987786"
  description = "AMI ID used ......"
  type = string

  validation {
    condition = length(var.image_id) > 4 && substr(var.image_id, 0, 4) == "ami-"
    error_message = "The image_id value must be a valid AMI id, starting with \"ami-\"."
  }
}

#variable "servers" {}

variable "environment" {
  type = string
  default = "staging"
  description = "The environment of instance"
}

variable "securityGroup" {
  type = list(number)
  default = [ 1,2,3,4 ]
  description = "The list of sg for this instance"
}

variable "instance_type" {
  type = list(string)
  default = [ "t2.nano", "t2.micro" ]
  description = "The list of instance type"
}

variable "blocks" {
  type = list(object({
    device_name = string
    volume_type = string
    volume_size = string
  }))

  default = [
    {
      device_name = "/dev/sdg"
      volume_type = "gp2"
      volume_size = 1
    },
    {
      device_name = "/dev/sdh"
      volume_type = "gp2"
      volume_size = 2
    }
  ]

  description = "List of EBS Block"
}

locals {
  ingress_rules = [{
    port = 443
    description = "Port 443"
  },
  {
    port = 80
    description = "Port 80"
  }]
}

variable "enable_sg" {
  type = bool
  default = false
}