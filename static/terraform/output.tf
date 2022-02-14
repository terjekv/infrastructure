output "public_dns_login_node" {
  value       = aws_instance.login_node.*.public_dns
}

output "public_dns_stratum1_eu_west_node" {
  value       = aws_instance.stratum1_eu_west.*.public_dns
}

output "login_node_eip" {
  value       = aws_eip.login_node.*.public_dns
}

output "stratum1_eu_west_node_eip" {
  value       = aws_eip.stratum1_eu_west.*.public_dns
}

output "monitoring_node_eip" {
  value       = aws_eip.monitoring_node.*.public_dns
}

output "repo_node_eip" {
  value       = aws_eip.repo_node.*.public_dns
}

output "atlantis_node_dns" {
  value       = aws_eip.atlantis_node.*.public_dns
}

output "staging_bucket_url" {
  value       = aws_s3_bucket.staging_bucket.bucket_domain_name
}

output "snapshot_bucket_url" {
  value       = aws_s3_bucket.gentoo_snapshot_bucket.bucket_domain_name
}