variable "allocated_storage" {
  description = "Storage to allocate for database"
  default     = 10
  type        = number
}

variable "identifier" {
  description = "RDS database identifier"
  default     = "my-database"
  type        = string
}

variable "engine" {
  description = "RDS database engine: postgres, mysql, etc"
  default     = "postgres"
  type        = string
}

variable "engine_version" {
  description = "RDS database engine version"
  default     = "13.13"
  type        = string
}

variable "instance_class" {
  description = "RDS database instance class. Free tier available options: db.t3.micro, db.t4g.micro"
  default     = "db.t3.micro"
  type        = string
}

variable "username" {
  description = "RDS database master username"
  default     = "postgres"
  type        = string
}

variable "parameter_group_name" {
  description = "RDS database parameter group name"
  default     = "default.postgres13"
  type        = string
}

variable "skip_final_snapshot" {
  description = "RDS database skip final snapshot parameter. Default: true"
  default     = true
  type        = bool
}

variable "default_tags" {
  type = map(string)
  default = {
    owner = "dolii"
  }
}
