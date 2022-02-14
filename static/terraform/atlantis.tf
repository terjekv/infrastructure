data "template_file" "atlantis_user_data" {
  template = file("../cloud-init/atlantis.eessi-hpc.org.yaml")
}

resource "aws_instance" "atlantis_node" {
#  depends_on             = [aws_ebs_volume.home_volume]

  ami                    = data.aws_ami.x86_64.id
  instance_type          = var.instance_terraform
  vpc_security_group_ids = [aws_security_group.atlantis.id]
  key_name               = "${var.localuser}-core-deployer-key"
  monitoring             = true
  availability_zone      = "eu-west-1a"
  user_data              = data.template_file.atlantis_user_data.rendered

  root_block_device {
    volume_size = 20
  }

  lifecycle {
    ignore_changes = [ami, user_data]
  }

  tags = {
#    Owner = var.localuser
    Name = "[CORE] atlantis (terraform)"
  }
}

resource "aws_eip" "atlantis_node" {
  instance = aws_instance.atlantis_node.id
  vpc      = true

  tags = {
    Name = "atlantis (terraform)"
  }
}

resource "aws_route53_record" "atlantis" {
  zone_id = var.aws_route53_infra_zoneid
  name    = "atlantis.eessi-infra.org"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.atlantis_node.public_ip]
}
resource "aws_route53_record" "atlantis_infra" {
  zone_id = var.aws_route53_infra_hpc_zoneid
  name    = "atlantis.infra.eessi-hpc.org"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.atlantis_node.public_ip]
}

resource "aws_route53_record" "atlantis_cname_terraform" {
  zone_id = var.aws_route53_infra_zoneid
  name    = "terraform.eessi-infra.org"
  type    = "CNAME"
  ttl     = "300"
  records = ["atlantis.eessi-infra.org"]
}