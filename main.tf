terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.33.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = ">=2.22.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">=3.1.1"
    }
  }
}
variable "profile" {
  type    = string
  default = "099867171230_TerrariaAdmin"
}
variable "region" {
  type    = string
  default = "eu-west-2"
}
provider "aws" {
  profile = var.profile
  region  = var.region
  default_tags {
    tags = {
      project = "terraria-server"
      creator = "thomas"
    }
  }
}
