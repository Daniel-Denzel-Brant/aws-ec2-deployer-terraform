provider "aws" {
  region = var.instance_config.region
}

provider "aws" {
  shared_credentials_file = var.credentials.shared_credentials_file
  alias   = "destination"
  profile = "destination"
  region = var.instance_config.region
}

provider "aws" {
  shared_credentials_file = var.credentials.shared_credentials_file
  alias   = "source"
  profile = "source"
  region = var.instance_config.region
}

