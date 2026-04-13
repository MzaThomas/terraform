variable "sg_name" {
  description = "Security Group Name"
  type        = string
}

variable "sg_ingress_list" {
  description = "Security Group Ingress List"
  type        = list(number)
}

variable "public_instance_name" {
  description = "Public Instance Name"
  type        = string
}

variable "private_instance_name" {
  description = "Private Instance Name"
  type        = string
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
}
