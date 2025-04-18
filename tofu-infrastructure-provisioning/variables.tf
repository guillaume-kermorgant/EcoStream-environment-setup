# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-3"
}

variable "env_name" {
  description = "Environment name (dev, staging, prod...)"
  type        = string
  default     = "test"
}