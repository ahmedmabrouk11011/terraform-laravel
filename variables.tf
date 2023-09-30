#########################################
# Tags/Environment
#########################################

variable "tags" {
  description = "Tags for the project"
  type        = map(string)
}

variable "environment" {
  description = "AWS region"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "aws_profile" {
  description = "AWS profile"
  type        = string
  default     = "default"
}

#########################################
# VPC
#########################################

variable "vpc_name" {
  type        = string
  description = "The name of the vpc"
}

variable "vpc_cidr" {
  type        = string
  description = "The cidr block of the vpc"
}

variable "public_subnets" {
  type        = any
  description = "The cidr blocks of the public subnets"
}

variable "private_subnets" {
  type        = any
  description = "The cidr blocks of the private subnets"
}

variable "database_subnets" {
  type        = any
  description = "The cidr blocks of the database subnets"
}

#########################################
# EC2
#########################################

variable "ec2s" {
  description = "List Of EC2 parameters "
  type        = any
}



