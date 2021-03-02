provider "aws" {
  region = var.aws_region
}

resource "aws_key_pair" "deployer" {
  key_name = "${var.localuser}-core-deployer-key"
  public_key = file(var.keys["public"])
  tags = {
    Owner = var.localuser
  }
}

resource "aws_security_group" "open_node" {
  name = "open-node"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}