variable "vpc_cidr" {
    description = "VPC CIDR Block"
    type = string
}

variable "public_subnet_cidr" {
  description = "CIDR Block for public subnet"
  type = string
}

variable "private_subnet_cidr" {
  description = "CIDR Block for private subnet"
  type = string
}

variable "public_subnet_az" {
  description = "Availability Zone for public subnet"
  type = string
}

variable "private_subnet_az" {
  description = "Availability Zone for private subnet"
  type = string
}