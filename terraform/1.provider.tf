provider "aws" {
  region = var.aws_region
}

terraform {
  required_version = ">= 1.4.0"
  required_providers {
    aws = {
      version = "<= 6.0.0"
      source  = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket = "dileep5290202125"
    key    = "ansible.tfstate"
    region = "us-east-1"
  }
}
