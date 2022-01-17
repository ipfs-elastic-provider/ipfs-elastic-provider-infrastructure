terraform {
  backend "s3" {
    profile        = "ipfs"
    bucket         = "ipfs-aws-terraform-state"
    dynamodb_table = "ipfs-aws-terraform-state-lock"
    region         = "us-west-2"
    key            = "terraform.indexing.tfstate"
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

data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
    bucket = "ipfs-aws-terraform-state"
    key    = "terraform.shared.tfstate"
    region = "us-west-2"
  }
}

provider "aws" {
  profile =  var.profile
  region  = "us-west-2"
  default_tags {
    tags = {
      Team        = "NearForm"
      Project     = "AWS-IPFS"
      Environment = "POC"
      Subsystem   = "Indexing"
      ManagedBy   = "Terraform"
    }
  }
}

resource "aws_lambda_function" "uploader" {
  function_name = local.uploader_lambda.name
  filename      = "lambda_function_base_code.zip"
  role          = aws_iam_role.uploader_lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"

  environment {
    variables = {
        S3_BUCKET =	"ipfs-cars"
        NODE_ENV= "production"
      } 
  }

  depends_on = [
    aws_iam_role_policy_attachment.uploader_lambda_logs,
    aws_cloudwatch_log_group.uploader_log_group,
  ]
}

data "archive_file" "lambda_zip" {
    type          = "zip"
    source_file   = "lambda_base_code/index.js"
    output_path   = "lambda_function_base_code.zip"
}

module "api-gateway-to-lambda" {
  source = "../modules/api-gateway-to-lambda"
  lambda = aws_lambda_function.uploader
}

module "lambda-from-s3" {
  source = "../modules/lambda-from-s3"
  indexingLambdaName = "indexing"
  bucket = data.terraform_remote_state.shared.outputs.cars_bucket
  sqs_publishing_queue_url = data.terraform_remote_state.shared.outputs.sqs_publishing_queue_url
  aws_iam_role_policy_list = [
    data.terraform_remote_state.shared.outputs.s3_policy_read,
    data.terraform_remote_state.shared.outputs.s3_policy_write,
    data.terraform_remote_state.shared.outputs.dynamodb_blocks_policy,
    data.terraform_remote_state.shared.outputs.dynamodb_car_policy,
    data.terraform_remote_state.shared.outputs.sqs_policy_send
  ]
}
