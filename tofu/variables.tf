variable "region" {
  description = "AWS region"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for Amazon Linux 2"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}
