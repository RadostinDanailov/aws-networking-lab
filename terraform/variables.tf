variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "networking-lab"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_web_subnet_cidr" {
  description = "Private web subnet CIDR"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_db_subnet_cidr" {
  description = "Private DB subnet CIDR"
  type        = string
  default     = "10.0.3.0/24"
}

variable "public_key_path" {
  description = "Path to your SSH public key"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}
