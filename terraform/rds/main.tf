resource "random_password" "master_password_postgres" {
  length  = 20
  special = false
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = data.aws_subnets.default.ids

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_security_group" "postgres_sg" {
  name        = var.security_group.name
  description = var.security_group.description

  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port = var.default_postgres.database_port
    to_port   = var.default_postgres.database_port
    protocol  = "tcp"
    cidr_blocks = [
      data.aws_vpc.default.cidr_block
    ]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = var.default_tags
}

resource "aws_db_instance" "default" {
  allocated_storage      = var.default_postgres.storage
  identifier             = var.default_postgres.identifier
  engine                 = var.default_postgres.engine
  engine_version         = var.default_postgres.engine_version
  instance_class         = var.default_postgres.instance_class
  username               = aws_ssm_parameter.master_username_postgres.value
  password               = aws_ssm_parameter.master_password_postgres.value
  parameter_group_name   = var.default_postgres.parameter_group_name
  skip_final_snapshot    = var.default_postgres.skip_final_snapshot
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.postgres_sg.id]
  port                   = var.default_postgres.database_port

  tags = var.default_tags
}

resource "aws_ssm_parameter" "master_username_postgres" {
  name  = "/rds/postgres/username"
  type  = "SecureString"
  value = var.default_postgres.username

  tags = var.default_tags
}

resource "aws_ssm_parameter" "master_password_postgres" {
  name  = "/rds/postgres/password"
  type  = "SecureString"
  value = random_password.master_password_postgres.result

  tags = var.default_tags
}

resource "aws_ssm_parameter" "postgres_endpoint" {

  name  = "/rds/postgres/endpoint"
  value = aws_db_instance.default.endpoint
  type  = "String"

  tags = var.default_tags
}
