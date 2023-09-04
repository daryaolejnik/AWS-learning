#====== AWS Variables =========
aws_region = "us-east-1"

#====== Instance Variables =========
ec2_instance = {
  name          = "test-instance"
  instance_type = "t2.micro"
  ami_id        = "ami-0f34c5ae932e6f0e4"
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
