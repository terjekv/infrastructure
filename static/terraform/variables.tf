variable "aws_region" {
  default = "eu-west-1"
}

variable "aws_availability_zone" {
  default = "eu-west-1a"
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

variable "instance_login" {
    default = "t4g.micro"
}
