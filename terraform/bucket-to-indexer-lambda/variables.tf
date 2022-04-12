variable "profile" {
  type = string
}

variable "region" {
  type = string
}

variable "account-id" {
  type = string
}

variable "bucket" {
  type = object({
    bucket = string
    arn    = string
    id     = string
  })
}

variable "lambda_image"{
  type = string
}

variable "lambda_name" {
  type = string
  default = "bucket-to-indexer"
}

variable "lambda_memory" {
  type = number
  default = 1024
}

variable "lambda_timeout" {
  type = number
  default = 900
}