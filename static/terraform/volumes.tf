resource "aws_ebs_volume" "monitoring_persistent_volume" {
  availability_zone = "eu-west-1a"
  size = 50

  tags = {
    Name = "Monitoring : Data volume"
  }

  lifecycle {
    prevent_destroy = true
  }
}