terraform {
  required_version = "1.9.0"
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.83.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
