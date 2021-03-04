output "public_dns_login_node" {
  value       = aws_instance.login_node.*.public_dns
}

