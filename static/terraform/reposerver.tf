data "template_file" "user_data_repo" {
  template = file("../cloud-init/repo.eessi-hpc.org.yaml")
}

resource "aws_instance" "repo_node" {
  ami                    = data.aws_ami.x86_64.id
  instance_type          = var.instance_repo
  vpc_security_group_ids = [aws_security_group.open_web_node.id]
  key_name               = "${var.localuser}-core-deployer-key"
  monitoring             = true
  availability_zone      = "eu-west-1a"
  user_data              = data.template_file.user_data_repo.rendered

  root_block_device {
    volume_size = 20
  }

  lifecycle {
    ignore_changes = [ami, user_data]
  }

  tags = {
#    Owner = var.localuser
    Name = "[CORE] repo.eessi-hpc.org"
  }
}

resource "aws_eip" "repo_node" {
  instance = aws_instance.repo_node.id
  vpc      = true

  tags = {
    Name = "reposerver"
  }
}

resource "aws_route53_record" "repo" {
  zone_id = var.aws_route53_infra_zoneid
  name    = "repo.eessi-infra.org"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.repo_node.public_ip]
}
resource "aws_route53_record" "repo_infra" {
  zone_id = var.aws_route53_infra_hpc_zoneid
  name    = "repo.infra.eessi-hpc.org"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.repo_node.public_ip]
}
