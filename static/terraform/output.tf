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

