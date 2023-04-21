# AWS EC2 Instance Deployer using Terraform
Template to deploy AWS EC2 Instances by providing Terraform with a .tfvars file

# Root main.tf File
## Provider Inheritance with Aliases
Providers are given aliases to be inherited by child modules
When using child modules, the aliases must be configured appropriately.

### Example:
```
module "assume_role"{
  source = "./assume_role"

  providers = {
    aws.src = aws.source
    aws.dst = aws.destination
  }
}
```

Child modules must configure the aliases in their required_providers appropriately. A provider is not needed as it will inherit them from the parent module.
### Example:
```
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.74.2 "
      configuration_aliases = [ aws.src, aws.dst ]
    }
  }
```
## Child Inheritance Configuration
For child modules that require extra configurations in their providers, it can be done by providing a provider and an alias with the added configurations.
### Example Provider Code:
```
provider "aws" {
  alias = "dst"

  assume_role {
    role_arn     = var.assume_role_arn
  }
}
```

### Example Required Provider Code:
```
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.74.2"
      configuration_aliases = [ aws.dst ]
    }
  }
```

# Modules
## assume_role Module
Module used to create an IAM role with policies that allow Terraform to interact with EC2.
Looks up the IAM Policies using data "aws_iam_policy_document" to create the IAM policy json file. It then creates an IAM role using "aws_iam_role" and the created policy.
Policies can be modified in accordance to user need.

### Policy Code Example
```
data "aws_iam_policy_document" "assume_role" {
  provider = aws.dst
  statement {
    actions = [
      "sts:AssumeRole",
      "sts:TagSession",
      "sts:SetSourceIdentity"
    ]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.source.account_id}:root"]
    }
  }
}
```
### Policy Creation Example:
```
resource "aws_iam_role" "assume_role" {
  provider            = aws.dst
  name                = "assume_role"
  assume_role_policy  = data.aws_iam_policy_document.assume_role.json
  managed_policy_arns = [data.aws_iam_policy.ec2.arn]
  tags                = {}
}
```

Outputs the ARN of the created role to "role_arn", which will be used by other modules to assume the role.
### Output Code:
```
output "role_arn" {
  value = aws_iam_role.assume_role.arn
}
```

## instances Module
Module used to create the EC2 Security Group and EC2 Spot Instance.
Assumes the role provided by the "assume_role" module.

**data.tf** is used to extract subnet id(s) within a VPC rather than manually providing subnet id(s).
### Subnet(s) from VPC Example:
```
data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}
```
**main.tf** used to provide the key pair, and create the EC2 and Security Group(s). Code for the EC2 and Security Group creation [here](instance/main.tf).
### Key Pair code Example:
```
resource "aws_key_pair" "deployer" {
  key_name   = "terraform-service-key"
  public_key = var.key_pair
}
```
Provider in main.tf uses assume_role and the "role_arn" output from the previous module to assume the EC2 role.
```
provider "aws" {
  alias = "dst"

  assume_role {
    role_arn     = var.assume_role_arn <--------------------------------------
  }
}
```
**variables.tf** is equivalent to variables in **config.tf** from the parent module as variables are not inherited from parent modules.

## terraform.tfvars File
A **terraform.tfvars** file can be created to replace the defaults that are in the root **main.tf** file.
**terraform.tfvars** files will automatically be applied when running the "terraform apply" command. However, any other .tfvars can be used using this command:
```
terraform apply -var-file=NAME.tfvars
```

## Sample .tfvars
Example can be downloaded in the [example_terraform.tfvars](example_terraform.tfvars) file.
```
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

```
