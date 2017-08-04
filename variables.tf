variable "cluster_name" {
  type = "string"
}

variable "aws_region" {
  type    = "string"
  default = "us-east-2"
}

variable "aws_azs" {
  type    = "list"
  default = ["us-east-2a", "us-east-2b"]
}

variable "aws_cidr_block" {
  type    = "string"
  default = "10.20.0.0/16"
}

variable "mesos_regular_nodes" {
  type    = "string"
  default = 1
}

variable "mesos_gpu_nodes" {
  type    = "string"
  default = 1
}

variable "aws_key_name" {
  type = "string"
}

variable "aws_node_ami" {
  type    = "string"
  default = "ami-b2795cd7" # debian-jessie-amd64-hvm-2017-01-15-1221-ebs @ us-east-2
}

variable "aws_node_gpu_ami" {
  type = "string"
}

variable "aws_zk_ami" {
  type    = "string"
  default = "ami-b2795cd7" # debian-jessie-amd64-hvm-2017-01-15-1221-ebs @ us-east-2
}

variable "aws_master_ami" {
  type    = "string"
  default = "ami-b2795cd7" # debian-jessie-amd64-hvm-2017-01-15-1221-ebs @ us-east-2
}

variable "domain_name" {
  type    = "string"
  default = "mesos.private"
}
