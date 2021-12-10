variable "naming_prefix" {
  type        = string
  description = "Naming prefix for resources"
  default     = "npi-oregon-dev"
}

variable "aws_region" {
  type        = string
  description = "Region for AWS Resources"
  default     = "us-west-2"
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS hostnames in VPC"
  default     = true
}

variable "map_public_ip_on_launch" {
  type        = bool
  description = "Map a public IP address for Subnet instances"
  default     = false
}

variable "vpc_cidr_block" {
  type        = string
  description = "Base CIDR Block for VPC"
  default     = "10.88.0.0/16"
}

variable "vpc_subnet_count" {
  type        = number
  description = "Number of private or public subnets to create in VPC"
  default     = 4
}

variable "vpc_cidr_range_private_subnets" {
  type        = list(string)
  description = "CIDR ranges for private subnets"
  default     = ["10.88.128.0/23", "10.88.130.0/23", "10.88.132.0/23", "10.88.134.0/23"]
}

variable "vpc_cidr_range_public_subnets" {
  type        = list(string)
  description = "CIDR ranges for public subnets"
  default     = ["10.88.0.0/23", "10.88.2.0/23", "10.88.4.0/23", "10.88.6.0/23"]
}

variable "aws_azs" {
  type        = list(string)
  description = "AWS Available Zones to use"
  default     = ["us-west-2a", "us-west-2b", "us-west-2c", "us-west-2d"]
}
