variable "access_key" {
    description = "Access key to AWS console"
}
variable "secret_key" {
    description = "Secret key to AWS console"
}


variable "instance_name" {
    description = "Name of the instance to be created"
    default     = "awsbuilder-demo"
}

variable "instance_type" {
    default = "t2.micro"
}

variable "subnet_id" {
    description = "The VPC subnet the instance(s) will be created in"
    default     = "subnet-02a4260b7f2470c65"
}

variable "ami_id" {
    description = "The AMI to use, Amazon Linux 2023 AMI"
    default     = "ami-0f34c5ae932e6f0e4"
}

variable "number_of_instances" {
    description = "number of instances to be created"
    default     = 1
}

variable "instance_private_ip" {
    description = "Private IP for Instance"
    default     = "10.0.0.12"
}

variable "ami_key_pair_name" {
    default = "tomcat"
}

variable "default_tags" {
    type    = map(string)
    default = {
        owner = "dolii"
    }
}