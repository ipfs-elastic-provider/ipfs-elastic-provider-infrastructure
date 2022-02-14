terraform {
  backend "s3" {
    profile        = "ipfs"
    bucket         = "ipfs-elastic-provider-terraform-state"
    dynamodb_table = "ipfs-elastic-provider-terraform-state-lock"
    region         = "us-west-2"
    key            = "terraform.shared.tfstate"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.38"
    }
  }

  required_version = ">= 1.0.0"
}

provider "aws" {
  profile = var.profile
  region  = "us-west-2"
  default_tags {
    tags = {
      Team        = "NearForm"
      Project     = "IPFS-Elastic-Provider"
      Environment = "POC"
      Subsystem   = "Shared"
      ManagedBy   = "Terraform"
    }
  }
}

resource "aws_s3_bucket" "cars" {
  bucket = var.carsBucketName
  acl    = "private"
}

resource "aws_sqs_queue" "publishing_queue" {
  name                      = "publishing"
  receive_wait_time_seconds = 10
}

module "dynamodb" {
  source = "../modules/dynamodb"
  blocks_table = {
    name = "blocks"
  }

  cars_table = {
    name = "cars"
  }
}
