variable "ami_name" {
  type = string
  default = "eessi-rhel-8-arm64-{{ timestamp }}"
}

variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "eessi_login_keys" {
  type    = string
  default = env("EESSI_SSH_KEYS")
}

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioners and post-processors on a
# source.
source "amazon-ebs" "firstrun" {
  ami_name      = var.ami_name
  instance_type = "t4g.micro"
  region        = var.region
  source_ami_filter {
    filters = {
      name                = "RHEL-8*arm64-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["309956199498"]
  }
  ssh_username = "ec2-user"
  tags = {
    OS_Version = "RHEL"
    Base_AMI_ID = "{{ .SourceAMI }}"
    Base_AMI_Name = "{{ .SourceAMIName }}"
    Name = "EESSI x86_64 default node"
  }

}

# a build block invokes sources and runs provisioning steps on them.
build {
  sources = ["source.amazon-ebs.firstrun"]

  provisioner "shell" {
    environment_vars = [
      "EESSI_SSH_KEYS=${var.eessi_login_keys}"
    ]
    script = "./provision.sh"
  }
}
