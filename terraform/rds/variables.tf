variable "default_postgres" {
  description = "Parameters to create default rds postgres db"
  type = object({
    storage              = number
    identifier           = string
    engine               = string
    engine_version       = string
    instance_class       = string
    username             = string
    parameter_group_name = string
    skip_final_snapshot  = bool
  })
}

variable "security_group" {
  description = "Default parameter for rds postgres db security group"
  type = object({
    name          = string
    description   = string
    database_port = number
  })
}

variable "default_tags" {
  type = map(string)
  default = {
    owner = "dolii"
  }
}
