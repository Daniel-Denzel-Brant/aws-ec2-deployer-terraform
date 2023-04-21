data "aws_caller_identity" "source" {
  provider = aws.dst
}

data "aws_iam_policy" "ec2" {
  provider = aws.src
  name     = "AmazonEC2FullAccess"
}

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

resource "aws_iam_role" "assume_role" {
  provider            = aws.dst
  name                = "assume_role"
  assume_role_policy  = data.aws_iam_policy_document.assume_role.json
  managed_policy_arns = [data.aws_iam_policy.ec2.arn]
  tags                = {}
}

