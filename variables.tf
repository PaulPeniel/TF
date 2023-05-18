variable "vpc_cidr" {
  description = "cidr block for vpc"
  type        = string
}

variable "public_cidr" {
  description = "public cidrs for public subnets"
  type        = list(string)
}

variable "private_cidr" {
  description = "private cidrs for public subnets"
  type        = list(string)
}

variable "database_cidr" {
  description = "database cidrs for backend servers"
}

variable "enable_dns_hostnames" {
  type = bool
}

variable "enable_dns_support" {
  type = bool
}

variable "tags" {
  default {
    Owner   = "Paul"
    Project = "Terraform"
  }
}

variable "Environment" {
  description = "where this is hosted"
  type        = string
}

variable "azs" {
  description = "data centers"
  type        = list(string)
}

variable "ami" {
  type = list(string)
}

variable "key_name" {
  type = string
}

variable "instance_type" {
  type = list(string)
}