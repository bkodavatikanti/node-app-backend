terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.64.0"
      #version = "~> 5.0"
    }
  }

   backend "s3" {
    bucket = "statelock461"
    key    = "app-back-end"
    region = "ap-south-1"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
}
