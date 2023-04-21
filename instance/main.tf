provider "aws" {
  alias = "dst"

  assume_role {
    role_arn     = var.assume_role_arn
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "terraform-service-key"
  public_key = var.key_pair
}

resource "aws_spot_instance_request" "instance" {
  for_each                    = toset(data.aws_subnets.subnets.ids)
  ami                         = var.chosen_ami
  availability_zone           = var.ec2.availability_zone
  instance_type               = var.ec2.instance_type
  spot_price                  = var.spot.spot_price
  spot_type                   = var.spot.spot_type
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.sg.id]
  subnet_id                   = each.value
  key_name                    = aws_key_pair.deployer.id
  root_block_device {
    delete_on_termination = true
    encrypted             = false
    volume_size           = var.ec2.volume_size
    volume_type           = var.ec2.volume_type
  }
  //user_data = file("templates/${var.ec2.os_type}.sh")
  tags = {
    Name = "Terraform"
  }
}

resource "aws_security_group" "sg" {
  description = "Terraform generated SG"
  vpc_id      = var.vpc_id
  //ingress {
    //description = "Laptop Outbount IP"
    //from_port   = 22
    //to_port     = 22
    //protocol    = "tcp"
    //cidr_blocks = ["172.31.0.0/20"]
  //}
  dynamic "ingress" {
    for_each = var.security_groups
    content {
      description = ingress.value["name"]
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}