variable "aws_access_key" {
  type    = string
  default = ""
}

variable "aws_secret_key" {
  type    = string
  default = ""
}

variable "name_prefix" {
  type        = string
  default     = "nodejs-cluster"
  description = "Prefix to be used on each infrastructure object Name created in AWS."
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  type    = string
  default = "test"
}

variable "admin_users" {
  type        = list(string)
  default     = ["triple-a"]
  description = "List of Kubernetes admins."
}

variable "developer_users" {
  type        = list(string)
  default     = []
  description = "List of Kubernetes developers."
}

variable "main_network_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "Base CIDR block to be used in our VPC."
}

variable "subnet_prefix_extension" {
  type        = number
  default     = 4
  description = "CIDR block bits extension to calculate CIDR blocks of each subnetwork."
}

variable "zone_offset" {
  type        = number
  default     = 8
  description = "CIDR block bits extension offset to calculate Public subnets, avoiding collisions with Private subnets."
}

variable "asg_sys_instance_types" {
  type        = list(string)
  default     = ["t3a.medium"]
  description = "List of EC2 instance machine types to be used in EKS for the system workload."
}

variable "asg_dev_instance_types" {
  type        = list(string)
  default     = ["t3a.medium"]
  description = "List of EC2 instance machine types to be used in EKS for development workload."
}

variable "autoscaling_minimum_size_by_az" {
  type        = number
  default     = 1
  description = "Minimum number of EC2 instances to auto-scale our EKS cluster on each AZ."
}

variable "autoscaling_maximum_size_by_az" {
  type        = number
  default     = 2
  description = "Maximum number of EC2 instances to auto-scale our EKS cluster on each AZ."
}

variable "autoscaling_average_cpu" {
  type        = number
  default     = 60
  description = "Average CPU threshold to auto-scale EKS EC2 instances."
}
