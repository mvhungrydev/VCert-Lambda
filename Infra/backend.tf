terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket = "terraform-state-mv"          # S3 bucket
    key    = "vcert-lambda/terraform.tfstate"   # path inside bucket
    region = "us-east-1"                        # bucket region
    encrypt = true                              # encrypt state at rest
    use_lockfile = true                         # enable S3-native locking (no DynamoDB)
  }
}

provider "aws" {
  region = "us-east-1"
}
