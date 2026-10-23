resource "aws_s3_bucket" "ib_components" {
  bucket = "ec2-devbox-image-builder-components"

  tags = {
    project = "ec2_devbox"
    module  = "ami-builder"
  }
}

resource "aws_s3_bucket_public_access_block" {
  bucket = aws_s3_bucket.ib_components.bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "ib_bucket_policy" {
  bucket = aws_s3_bucket.ib_components.bucket
  policy = data.aws_policy_document.ib_bucket_policy.json
}

data "aws_iam_policy_document" "ib_bucket_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.ec2_devbox_ib_role.arn]
    }
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.ib_components.arn,
      "${aws_s3_bucket.ib_components.arn}/*"
    ]
  }
}

resource "aws_s3_object" "ec2_devbox_setup" {
  bucket = aws_s3_bucket.ib_components.bucket
  key    = "ec2_devbox_setup"
  source = "${path.module}/setup_devbox.yaml"

  etag = filemd5("${path.module}/setup_devbox.yaml")
}
