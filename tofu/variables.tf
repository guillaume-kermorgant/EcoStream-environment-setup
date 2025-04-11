variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "ec2_conf" {
  description = "EC2 instance configuration"
  type        = map(string)
}
