terraform {
  required_version = "1.10.5"
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
