data "aws_ami" "aarch64" {
  most_recent = true

  filter {
    name   = "name"
    values = ["RHEL-8*arm64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["309956199498"] # RHEL
}

data "aws_ami" "x86_64" {
  most_recent = true

  filter {
    name   = "name"
    values = ["RHEL-8*x86_64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["309956199498"] # RHEL
}

data "aws_ami" "macos_catalina" {
  most_recent = true
  owners = ["amazon"] 

  filter {
    name   = "name"
    values = ["amzn-ec2-macos-10.15.*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

data "aws_ami" "macos_big_sur" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ec2-macos-11.2.*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}
