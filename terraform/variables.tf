variable "shared_prefix" {
  default = "apr1"
}

variable "aws_region" {
  default = "ap-northeast-1"
}

variable "aws_azs" {
  default = [
    "ap-northeast-1a",
    "ap-northeast-1c",
    "ap-northeast-1d",
  ]
}
