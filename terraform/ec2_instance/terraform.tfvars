#====== AWS Variables =========
aws_region = "us-east-1"

#====== Ami Variables =========
amazon_linux_ami = {
  name                = ["al2023-ami-2023.*-x86_64"]
  owners              = ["amazon"]
  root_device_type    = ["ebs"]
  virtualization_type = ["hvm"]
}

#====== Instance Variables =========
ec2_instance = {
  name          = "test-instance"
  instance_type = "t2.micro"
  key_name      = "httpd"
}

#====== Network Variables ==========
vpc = {
  name            = "my-vpc"
  cidr            = "10.0.0.0/22"
  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.3.0/24"]
}

#====== Security Group Variables ==========
security_group = {
  name        = "my-security-group"
  description = "Security group for web-server with HTTP ports open within VPC"

  egress_rules        = ["all-all"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp"]
}
