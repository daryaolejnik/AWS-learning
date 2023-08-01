provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "us-east-1"
}

resource "aws_vpc" "vpc" {
    cidr_block       = "10.0.0.0/16"
    instance_tenancy = "default"

    tags = "${var.default_tags}"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "subnet" {
    vpc_id     = aws_vpc.vpc.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1e"
    map_public_ip_on_launch = true

    tags = "${var.default_tags}"
    depends_on = [aws_internet_gateway.igw]
}

resource "tls_private_key" "rsa-4096" {
    algorithm = "RSA"
    rsa_bits  = 4096
}

resource "aws_key_pair" "ssh_key" {
    key_name   = "${var.ami_key_pair_name}"
    public_key = tls_private_key.rsa-4096.public_key_openssh
    tags       = "${var.default_tags}"
}

resource "aws_instance" "ec2_instance" {
    ami             = "${var.ami_id}"
    count           = "${var.number_of_instances}"
    subnet_id       = "${aws_subnet.subnet.id}"
    instance_type   = "${var.instance_type}"
    private_ip      = "${var.instance_private_ip}"
    key_name        = "${var.ami_key_pair_name}"
    user_data       = "${file("../ec2-user-data.sh")}"
    tags            = "${var.default_tags}"
}   

resource "aws_eip" "eip" {
  domain = "vpc"

  instance                  = aws_instance.ec2_instance[0].id
  associate_with_private_ip = "${var.instance_private_ip}"
  tags                      = "${var.default_tags}"
  depends_on                = [aws_internet_gateway.igw]
}