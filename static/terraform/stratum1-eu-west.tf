data "template_file" "user_data_stratum1" {
  template = file("../cloud-init/stratum1-eu-west.eessi-hpc.org.yaml")
}

resource "aws_instance" "stratum1_eu_west" {
#  depends_on             = [aws_ebs_volume.stratum1_eu_west]

  ami                    = data.aws_ami.x86_64.id
  instance_type          = var.instance_stratum1
  vpc_security_group_ids = [aws_security_group.stratum1.id]
  key_name               = "${var.localuser}-core-deployer-key"
  monitoring             = true
  availability_zone      = "eu-west-1a"
  user_data              = data.template_file.user_data_stratum1.rendered

  root_block_device {
    volume_size = 20
  }

  tags = {
#    Owner = var.localuser
    Name = "[CORE] stratum1-eu-west.eessi-hpc.org"
  }
}

resource "aws_eip" "stratum1_eu_west" {
  instance = aws_instance.stratum1_eu_west.id
  vpc      = true
}

resource "aws_volume_attachment" "stratum1_eu_west_attachment" {
  depends_on   = [aws_instance.stratum1_eu_west]
  device_name  = "/dev/sdh"
  volume_id    = "vol-0f85254bbd75761f4"
  instance_id  = aws_instance.stratum1_eu_west.id
  force_detach = true
}
