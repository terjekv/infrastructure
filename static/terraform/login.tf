data "template_file" "user_data" {
  template = file("../cloud-init/login.eessi-hpc.org.yaml")
}

resource "aws_instance" "login_node" {
#  depends_on             = [aws_ebs_volume.home_volume]

  ami                    = data.aws_ami.aarch64.id
  instance_type          = var.instance_login
  vpc_security_group_ids = [aws_security_group.open_node.id]
  key_name               = "${var.localuser}-core-deployer-key"
  monitoring             = true
  availability_zone      = "eu-west-1a"
  user_data              = data.template_file.user_data.rendered

  root_block_device {
    volume_size = 20
  }

  tags = {
#    Owner = var.localuser
    Name = "[CORE] login.eessi-hpc.org"
  }
}

#resource "aws_ebs_volume" "home_volume" {
#  availability_zone = "eu-west-1a"
#  size = 20
#
#  tags = {
#    Name = "Login : Home directories"
#  }

#  lifecycle {
#    prevent_destroy = true
#  }
#}

resource "aws_volume_attachment" "home-attachment" {
  depends_on   = [aws_instance.login_node]
  device_name  = "/dev/sdh"
  volume_id    = "vol-0002925059d439a40"
  instance_id  = aws_instance.login_node.id
  force_detach = true
}