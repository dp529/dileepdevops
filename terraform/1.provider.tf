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
  # Uncomment to enable S3 remote state. Your IAM user must have:
  #   s3:GetObject, s3:PutObject, s3:ListBucket on the target bucket
  # backend "s3" {
  #   bucket = "YOUR_TERRAFORM_STATE_BUCKET"
  #   key    = "ansible.tfstate"
  #   region = "us-east-1"
  # }
}
