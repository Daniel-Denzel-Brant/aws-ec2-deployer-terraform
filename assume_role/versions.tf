terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.74.2 "
      configuration_aliases = [ aws.src, aws.dst ]
    }
  }

  required_version = ">= 0.15"
}
