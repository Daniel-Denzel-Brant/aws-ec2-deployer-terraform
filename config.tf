variable "credentials" {
  type = object({
    shared_credentials_file = string
    key_pair                = string
  })
  default = {
      shared_credentials_file = "REDACTED"
      key_pair = "REDACTED"
    }
}

variable "instance_config" {
  type = object({
    region          = string
    vpc_id          = string
    chosen_ami      = string
  })

  default = {
      region        = "ap-northeast-1"
      vpc_id        = "REDACTED"
      chosen_ami    = "REDACTED"
      //chosen_ami  = "REDACTED"
    }
}

variable "default_security_groups" {
  description = "The attribute of security_groups information"
  type = list(object({
    name        = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [{
    from_port   = 0
    name        = "REDACTED"
    protocol    = "REDACTED"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    },
    {
    from_port   = 0
    name        = "REDACTED"
    protocol    = "REDACTED"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }]
}

variable "default_ec2" {
  description = "The attribute of EC2 information"
  type = object({
    name              = string
    os_type           = string
    instance_type     = string
    volume_size       = number
    volume_type       = string
    availability_zone = string
  })
  default = {
    //instance_type     = "REDACTED"
    instance_type       = "REDACTED"
    name                = "REDACTED"
    os_type             = "REDACTED"
    volume_size         = 0
    volume_type         = "REDACTED"
    availability_zone   = "REDACTED"
  }
}

variable "default_spot"{
  type = object({
    spot_price        = string
    spot_type         = string
  })
  default = {
    spot_price = "REDACTED"
    spot_type = "REDACTED"
  }
}


module "assume_role"{
  source = "./assume_role"

  providers = {
    aws.src = aws.source
    aws.dst = aws.destination
  }
}

module "instance" {
  source = "./instance"
  security_groups   = var.default_security_groups
  ec2               = var.default_ec2
  spot              = var.default_spot
  chosen_ami        = var.instance_config.chosen_ami
  vpc_id            = var.instance_config.vpc_id
  key_pair          = var.credentials.key_pair
  assume_role_arn   = module.assume_role.role_arn
}