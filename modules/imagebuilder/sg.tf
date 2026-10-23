resource "aws_security_group" "ib_sg" {
  name        = "ec2-devbox-ib-default"
  description = "new default sg for ami-builder vpc"

  tags = {
    module  = "ami-builder"
    project = "ec2_devbox"
  }
}

resource "aws_security_group_rule" "ib_subnet" {
  name        = "ec2-devbox-ib-allow-internet"
  description = "allow ami-builder instance access to internet"

  tags = {
    module   = "ami-builder"
    proiject = "ec2_devbox"
  }
}
