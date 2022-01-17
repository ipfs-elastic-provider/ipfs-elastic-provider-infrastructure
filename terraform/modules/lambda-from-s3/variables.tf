variable "indexingLambdaName" {
  type = string
}

variable "bucket" {
  type = object({
    bucket = string
    arn    = string
    id     = string
  })
}

variable "sqs_publishing_queue_url" {
  type = string
}

variable "aws_iam_role_policy_list" {
  type = list(object({
    name = string,
    arn  = string,
  }))
  description = "This list contains policies that will be attached to the current role"
}
