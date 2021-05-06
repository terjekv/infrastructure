data "template_file" "monitoring_user_data" {
  template = file("../cloud-init/monitoring.eessi-hpc.org.yaml")
}

resource "aws_instance" "monitoring_node" {
#  depends_on             = [aws_ebs_volume.home_volume]

  ami                    = data.aws_ami.x86_64.id
  instance_type          = var.instance_monitoring
  vpc_security_group_ids = [aws_security_group.open_web_node.id]
  key_name               = "${var.localuser}-core-deployer-key"
  monitoring             = true
  availability_zone      = "eu-west-1a"
  user_data              = data.template_file.monitoring_user_data.rendered

  root_block_device {
    volume_size = 20
  }

  lifecycle {
    ignore_changes = [ami, user_data]
  }

  tags = {
#    Owner = var.localuser
    Name = "[CORE] monitoring.infra.eessi-hpc.org"
  }
}

resource "aws_volume_attachment" "monitoring-attachment" {
  depends_on   = [aws_instance.monitoring_node]
  device_name  = "/dev/sdh"
  volume_id    = aws_ebs_volume.monitoring_persistent_volume.id
  instance_id  = aws_instance.monitoring_node.id
  force_detach = true
}


resource "aws_eip" "monitoring_node" {
  instance = aws_instance.monitoring_node.id
  vpc      = true

  tags = {
    Name = "monitoring"
  }
}

resource "aws_route53_record" "monitoring" {
  zone_id = var.aws_route53_infra_zoneid
  name    = "monitoring.eessi-infra.org"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.monitoring_node.public_ip]
}
resource "aws_route53_record" "monitoring_infra" {
  zone_id = var.aws_route53_infra_hpc_zoneid
  name    = "monitoring.infra.eessi-hpc.org"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.monitoring_node.public_ip]
}
