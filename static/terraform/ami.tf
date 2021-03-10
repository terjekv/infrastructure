data "aws_ami" "aarch64" {
  most_recent = true

  filter {
    name   = "name"
    values = ["eessi-rhel-8*arm64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["self"] 
}

data "aws_ami" "x86_64" {
  most_recent = true

  filter {
    name   = "name"
    values = ["eessi-rhel-8*x86_64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["self"] 
}
