provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.aws_region
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

  name = var.vpc.name
  cidr = var.vpc.cidr

  azs             = var.vpc.azs
  private_subnets = var.vpc.private_subnets
  public_subnets  = var.vpc.public_subnets

  enable_nat_gateway = true

  tags = var.default_tags
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = var.security_group.name
  description = var.security_group.description
  vpc_id      = module.vpc.vpc_id

  egress_rules        = var.security_group.egress_rules
  ingress_cidr_blocks = var.security_group.ingress_cidr_blocks
  ingress_rules       = var.security_group.ingress_rules

  tags = var.default_tags
}

resource "tls_private_key" "rsa-4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ssh_key" {
  key_name   = var.ec2_instance.key_name
  public_key = tls_private_key.rsa-4096.public_key_openssh

  tags = var.default_tags
}
data "aws_ami" "amazon_linux_ami" {
  owners      = var.amazon_linux_ami.owners
  most_recent = true

  filter {
    name   = "name"
    values = var.amazon_linux_ami.name
  }

  filter {
    name   = "root-device-type"
    values = var.amazon_linux_ami.root_device_type
  }

  filter {
    name   = "virtualization-type"
    values = var.amazon_linux_ami.virtualization_type
  }
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.5.0"

  ami                         = data.aws_ami.amazon_linux_ami.image_id
  name                        = var.ec2_instance.name
  instance_type               = var.ec2_instance.instance_type
  key_name                    = aws_key_pair.ssh_key.key_name
  vpc_security_group_ids      = [module.security_group.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  user_data                   = file("../ec2-user-data.sh")

  tags = var.default_tags

  depends_on = [
    module.security_group,
    aws_key_pair.ssh_key
  ]
}

resource "aws_eip" "elastic_ip_for_ec2" {
  domain   = "vpc"
  instance = module.ec2_instance.id

  tags = var.default_tags
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = module.ec2_instance.id
  allocation_id = aws_eip.elastic_ip_for_ec2.id
}
