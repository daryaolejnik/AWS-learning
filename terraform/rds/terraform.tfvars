#====== Ami Variables =========
default_postgres = {
  storage              = 10
  identifier           = "my-database"
  engine               = "postgres"
  engine_version       = "13.13"
  instance_class       = "db.t3.micro"
  username             = "postgres"
  parameter_group_name = "default.postgres13"
  skip_final_snapshot  = true
  database_port        = 5432
}

security_group = {
  name        = "postgresql-sg"
  description = "Default PostgreSQL Security Group"
}
