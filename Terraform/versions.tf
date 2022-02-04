# Provider Block
provider "aws" {
  region  = "us-east-2"
  profile = "default"
}
terraform {
  required_version = "~> 1.1.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}