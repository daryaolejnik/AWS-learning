# AWS - Learning

This is a repository with Terraform files for AWS Learning purpose

# Preparation

To create an ec2 instance you need to create a credentials.tfvars file with the following contents:
```
access_key = "<aws_access_key>"
secret_key = "<aws_secret_key>"
```

Then at startup time the path to this file should be defined as: `-var-file=<path_to_credentials.tfvars>`