# Stratum 0
resource "aws_route53_record" "stratum0_rug" {
  zone_id = var.aws_route53_infra_zoneid
  name    = "rug-nl.cvmfs.stratum0.eessi-infra.org"
  type    = "A"
  ttl     = "300"
  records = "129.125.60.179"
}

resource "aws_route53_record" "stratum0_cname" {
  zone_id = var.aws_route53_infra_zoneid
  name    = "cvmfs-s0.eessi-infra.org"
  type    = "CNAME"
  ttl     = "5"
  records = aws_route53_record.stratum0_rug.name
}

# Stratum 1
resource "aws_route53_record" "stratum1_rug" {
  zone_id = var.aws_route53_infra_zoneid
  name    = "rug-nl.cvmfs.stratum1.eessi-infra.org"
  type    = "A"
  ttl     = "300"
  records = "129.125.55.102"
}

resource "aws_route53_record" "stratum1_bgo" {
  zone_id = var.aws_route53_infra_zoneid
  name    = "bgo-no.cvmfs.stratum1.eessi-infra.org"
  type    = "A"
  ttl     = "300"
  records = "158.39.77.95"
}

resource "aws_route53_record" "stratum1_azure" {
  zone_id = var.aws_route53_infra_zoneid
  name    = "azure-us-east1.cvmfs.stratum1.eessi-infra.org"
  type    = "A"
  ttl     = "300"
  records = "40.71.46.52"
}

resource "aws_route53_record" "stratum1_eu_west_infra_aws" {
  zone_id = var.aws_route53_infra_zoneid
  name    = "aws-eu-west1.cvmfs.stratum1.eessi-infra.org"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.stratum1_eu_west.public_ip]
}
