variable "vpc_id" {
  type = string
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "azs" {
  type = list(string)
}

variable "environment" {
  type = string
}
