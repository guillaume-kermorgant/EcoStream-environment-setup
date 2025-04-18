# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {

  # variables are passed in from .gitlab-ci.yml
  # comment this to run locally
   backend "http" {
    address = ""
    lock_address = ""
    unlock_address = ""
    username = ""
    password = ""
    lock_method    = "POST"
    unlock_method  = "DELETE"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.83.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.1"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.5"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.3.4"
    }
  }

  required_version = "~> 1.3"
}

