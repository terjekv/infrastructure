provider "aws" {
  region = var.aws_region
}

resource "aws_key_pair" "deployer" {
  key_name = "${var.localuser}-deployer-key"
  public_key = file(var.keys["public"])
  tags = {
    Owner = var.localuser
  }
}

data "http" "icanhazip" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group" "instance" {
  name = "${var.localuser}-eessi-security"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.icanhazip.body)}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "instance_open_public" {
  security_group_id = aws_security_group.instance.id
  count     = var.is_public ? 1 : 0
  type      = "ingress"
  from_port = 22
  to_port   = 22
  cidr_blocks = ["0.0.0.0/0"]
  protocol  = "tcp"
}

