terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.10"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">=4.0"
    }
  }
}
