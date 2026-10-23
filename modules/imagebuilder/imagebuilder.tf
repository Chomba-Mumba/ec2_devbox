resource "aws_imagebuilder_image_pipleine" "ib_pipeline" {
  image_recipe_arn                 = aws_imagebuilder_image_recipe.ib_recipe.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.ib_conf.arn
  name                             = "ec2-devbox-ib-pipeline"

  lifecycle {
    replace_triggered_by = [
      aws_imagebuilder_image_recipe.ib_recipe
    ]
  }
}

resource "aws_imagebuilder_image_recipe" "ib_recipe" {
  block_device_mapping {
    device_name = "/dev/xvdb"

    ebs {
      delete_on_termination = true
      volume_size           = 100
      volume_type           = "gp2"
    }
  }
  tags = {
    project = "ec2_devbox"
    module  = "ami_builder"
  }
}

resource "aws_image_builder_component" "ib_comp" {
  name     = "ec2_devbox_setup"
  platform = "Linux"
  uri      = "s3://${aws_s3_object.ec2_devbox_setup.bucket}/${aws_s3_object.ec2_devbox_setup.key}"
  version  = "1.0.0"

}

resource "aws_imagebuilder_infrastructure_configuration" "ib_conf" {
  description                   = "infrastructure configuration used to run the imagebuilder pipeline for the ec2 devbox."
  instance_profile_name         = aws_iam_instance_profile.ib_profile.name
  instance_types                = ["t2.medium"]
  name                          = "ec2-devbox-ib-instance"
  security_group_ids            = [aws_security_group.ib_sg.id]
  subnet_id                     = aws_subnet.ib_subnet
  terminate_instance_on_failure = true

  tags = {
    project = "ec2_devbox"
    module  = "ami_builder"
  }
}
