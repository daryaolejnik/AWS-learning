variable "access_key" {
  description = "Access key to AWS console"
  sensitive   = true
}
variable "secret_key" {
  description = "Secret key to AWS console"
  sensitive   = true
}

variable "aws_region" {
  description = "AWS Region for infrastructure"
}

variable "vpc" {
  type = object({
    name            = string
    cidr            = string
    azs             = list(string)
    private_subnets = list(string)
    public_subnets  = list(string)
  })
}

variable "security_group" {
  type = object({
    name        = string
    description = string

    egress_rules        = list(string)
    ingress_cidr_blocks = list(string)
    ingress_rules       = list(string)
  })
}

variable "ec2_instance" {
  type = object({
    name          = string
    instance_type = string
    ami_id        = string
    key_name      = string
  })
}

variable "default_tags" {
  type = map(string)
  default = {
    owner = "dolii"
  }
}
