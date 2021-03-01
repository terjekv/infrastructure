variable "aws_region" {
  default = "eu-west-1"
}

variable "mode" {
  type = string

  validation {
    condition = var.mode == "small" || var.mode == "medium" || var.mode == "large"
    error_message = "Set TF_VAR_mode to 'small', 'medium', or 'large'."
  }
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

variable "localuser" {
  default = "unknown-user"
}

variable "is_public" {
  default = false
}

variable "create_x86_64" {
  default = false
}

variable "create_aarch64" {
  default = false
}

variable "create_macos_catalina_aarch64" {
  default = false
}

variable "create_macos_catalina_x86_64" {
  default = false
}

variable "create_macos_big_sur_aarch64" {
  default = false
}

variable "create_macos_big_sur_x86_64" {
  default = false
}

variable "instance_aarch64" {
  type = map

  default = {
    small = "t4g.micro"
    medium = "c6g.xlarge"
    large = "c6g.4xlarge"
  }
}

variable "instance_x86_64" {
  type = map

  default = {
    small = "t2.micro"
    medium = "c5.xlarge"
    large = "c5.4xlarge"
  }
}

variable "instance_macos_aarch64" {
  type = map

  default = {
    small = "mac1.metal"
    medium = "mac1.metal"
    large = "mac1.metal"
  }
}

variable "instance_macos_x86_64" {
  type = map

  default = {
    small = "mac1.metal"
    medium = "mac1.metal"
    large = "mac1.metal"
  }
}

