credentials = {
    shared_credentials_file = "PATH TO .AWS/CREDENTIALS FILE"
    key_pair                = "SSH - RSA KEY"
}

instance_config = {
      region        = "REGION"
      vpc_id        = "VPC - ID"
      chosen_ami    = "AMI - ID"
}

default_security_groups = [
  {
    from_port   = 0
    name        = "NAME"
    protocol    = "PROTOCOL"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  },
  {
    from_port   = 0
    name        = "NAME"
    protocol    = "PROTOCOL"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
]

default_ec2 = {
  instance_type     = "INSTANCE TYPE"
  name              = "NAME"
  os_type           = "OST_TYPE"
  volume_size       = 0
  volume_type       = "VOLUME_TYPE"
  availability_zone = "EC2 AZ"
}

default_spot = {
  spot_price = "MAXIMUM SPOT PRICE"
  spot_type  = "SPOT TYPE"
}
