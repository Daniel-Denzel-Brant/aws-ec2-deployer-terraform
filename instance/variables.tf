variable "assume_role_arn" {
  type = string
}

variable "security_groups" {
  description = "The attribute of security_groups information"
  type = list(object({
    name        = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "ec2" {
  description = "The attribute of EC2 information"
  type = object({
    name              = string
    os_type           = string
    instance_type     = string
    volume_size       = number
    volume_type       = string
    availability_zone = string
  })
}

variable "spot"{
  type = object({
    spot_price        = string
    spot_type         = string
  })
}


variable "chosen_ami" {
  description = "chosen ami"
  type        = string
}


variable "vpc_id" {
  type = string
}

variable "key_pair" {
  type = string
}