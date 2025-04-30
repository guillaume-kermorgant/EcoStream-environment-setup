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

variable "route_53_zone_id" {
  description = "[Optional] Route 53 hosted zone id, required for using custom host name for EcoStream"
  type        = string
  default     = ""
}
