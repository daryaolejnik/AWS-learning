locals {
  ssm_prefix = "/rds/${var.engine}"
}

resource "random_password" "password" {
  length  = 20
  special = false
}

data "aws_vpc" "vpc" {
  default = true
}

data "aws_subnets" "subnet" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "main"
  subnet_ids = data.aws_subnets.subnet.ids
}

resource "aws_security_group" "security_group" {
  name        = "${var.engine}-sg"
  description = "The Security Group for ${var.engine} database"

  vpc_id = data.aws_vpc.vpc.id

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    cidr_blocks = [
      data.aws_vpc.vpc.cidr_block
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
}

resource "aws_db_instance" "db_instance" {
  allocated_storage      = var.allocated_storage
  identifier             = var.identifier
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  username               = aws_ssm_parameter.username.value
  password               = aws_ssm_parameter.password.value
  parameter_group_name   = var.parameter_group_name
  skip_final_snapshot    = var.skip_final_snapshot
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.security_group.id]
  port                   = 5432
}

resource "aws_ssm_parameter" "username" {
  name  = "${local.ssm_prefix}/username"
  type  = "SecureString"
  value = var.username
}

resource "aws_ssm_parameter" "password" {
  name  = "${local.ssm_prefix}/password"
  type  = "SecureString"
  value = random_password.password.result
}

resource "aws_ssm_parameter" "endpoint" {

  name  = "${local.ssm_prefix}/endpoint"
  value = aws_db_instance.db_instance.endpoint
  type  = "String"
}
