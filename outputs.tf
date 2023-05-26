output "ssh_private_key" {
  value     = tls_private_key.mac.private_key_pem
  sensitive = true
}

output "host_instance_name" {
  value = [for host in aws_ec2_host.mac : host.instance_type]
}

output "host_id" {
  value = [for host in aws_ec2_host.mac : host.id]
}

output "instance_public_ip" {
  value = [for instance in aws_instance.mac : instance.public_ip]
}
