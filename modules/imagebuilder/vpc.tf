resource "aws_vpc" "ib_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    module  = "ami-builder"
    project = "ec2_devbox"
  }
}

resource "aws_subnet" "ib_subnet" {
  vpc_id     = aws_vpc.ami_build_vpc
  cidr_block = cidrsubnet(aws_vpc.ami_build_vpc, 0, 1)
}
