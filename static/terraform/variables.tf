variable "aws_region" {
  default = "eu-west-1"
}

variable "aws_availability_zone" {
  default = "eu-west-1a"
}

variable "aws_route53_infra_hpc_zoneid" {
  default = "Z10412033IZUH86YLABLW"
}

variable "aws_route53_infra_zoneid" {
  default = "Z08669212W005E4G61IF8"
}

variable "localuser" {
  default = "eessi-admin"
}

variable "ssh" {
  type = map

  default = {
    port = 22
    user = "ec2-user"
  }
}

variable "keys" {
  type = map

  default = {
    private = "~/.ssh/id_rsa.terraform"
    public  = "~/.ssh/id_rsa.terraform.pub"
  }
}

variable "instance_stratum1" {
    default = "t3.xlarge"
}

variable "instance_monitoring" {
    default = "t3.xlarge"
}

variable "instance_login" {
    default = "t4g.micro"
}
