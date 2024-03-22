terraform {
  backend "s3" {
    bucket         = "doliinyk-terraform"
    key            = "rds"
    region         = "us-east-1"
    profile        = "learning"
    dynamodb_table = "state-locking"
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "learning"
}
