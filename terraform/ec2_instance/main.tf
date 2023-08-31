provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.aws_region
}
resource "tls_private_key" "rsa-4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ssh_key" {
  key_name   = var.ami_key_pair_name
  public_key = tls_private_key.rsa-4096.public_key_openssh
  tags       = var.default_tags
}

resource "aws_security_group" "public_security_group" {
  name   = "ec2-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "all"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = var.default_tags
}

resource "aws_instance" "ec2_instance" {
  ami             = var.ami_id
  count           = var.number_of_instances
  subnet_id       = var.subnet_id
  security_groups = [aws_security_group.public_security_group.id]
  instance_type   = var.instance_type
  key_name        = var.ami_key_pair_name
  user_data       = file("../ec2-user-data.sh")
  tags            = var.default_tags
}   