# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "5.65.0" }
  }

  backend "s3" {
    bucket = "blog-deployment-state"
    key    = "terraform.tfstate"
    region = "ap-southeast-2"
  }
}