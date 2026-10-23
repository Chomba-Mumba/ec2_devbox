resource "aws_iam_role" "ib_iam_role" {
  name = "ec2-devbox-ib-role"

  assume_role_policy = data.aws_iam_policy_document.ib_assume_policy

  tags = {
    project = "ec2_devbox"
    module  = "ami-builder"
  }
}

data "aws_iam_policy_document" "ib_assume_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_instance_profile" "ib_instance_profile" {
  name = "ec2_devbox_profile"
  role = aws_iam_role.ib_iam_role
}
