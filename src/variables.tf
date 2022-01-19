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

variable "batch_ami_id_tiny" {
  type        = string
  description = "AMI for Batch EC2 instances with 100GB storage"
  default     = "ami-08576a4860f85fa6d"
}

variable "ecs_instance_role_policy_arn" {
  type        = list(string)
  description = "IAM Role Policiy to attach to instances run within Batch"
  default     = ["arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role", "arn:aws:iam::aws:policy/AmazonS3FullAccess", "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"]
}

variable "ecs_batch_service_role_policy_arns" {
  type        = list(string)
  description = "IAM Role Policies for Batch to be able to start instances"
  default     = ["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess", "arn:aws:iam::aws:policy/AmazonS3FullAccess", "arn:aws:iam::aws:policy/CloudWatchFullAccess", "arn:aws:iam::aws:policy/AmazonECS_FullAccess", "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole", "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"]
}

variable "batch_ec2_key" {
  type        = string
  description = "EC2 key pair for Batch instances"
  default     = "npi_aws_batch"
}

variable "data_instance_ip1" {
  type        = string
  description = "Private IP for Instance for Data Analysis Dashboard 1"
  default     = "10.88.1.27"
}
