variable "ports" {
  type = list(number)
  default = [22,443,80]
  
}
variable "ingress_cidr" {
type = string
default = "0.0.0.0/0"
  
}
variable "egress_port" {
  type = number
  default = -1
}
variable "egress_cidr" {
  type = string
  default = "0.0.0.0/0"
  
}
variable "image_id" {
    type = string
    default = "ami-052efd3df9dad4825"
  
}
variable "instance_type" {
  type = string
  default = "t2.micro"
}
variable "key_name" {
    type = string
    default = "key-tf"
  
}
variable "subnet_cidr" {
  type= string
  default= "10.0.1.0/24"
}
variable "aws_route_table_cidr" {
  type = string
  default = "0.0.0.0/0"
  
}
variable "aws_route_table_ipv6_cidr_block" {
  type = string
  default = "::/0"
}

variable "aws_subnet_cidr" {
  type = string
  default = "10.0.1.0/24"
  
}
variable "availability_zone" {
  type = string
  default = "us-east-1a"
}
variable "aws_network_interface_private_ip" {
  type = string
  default = "10.0.1.50"
  
}
variable "aws_eip_associate_with_private_ip" {
  type = string
  default = "10.0.1.50"
}