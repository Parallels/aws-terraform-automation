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

output "hosts_external_ips" {
  value = [for instance in parallels-desktop_deploy.deploy : instance.external_ip]
}

# output "host_internal_ip" {
#   value = parallels-desktop_remote_vm.builder-test.internal_ip
# }

# output "host_url" {
#   value = parallels-desktop_remote_vm.builder-test.host_url
# }

# output "vms_external_ips" {
#   value = [for instance in data.parallels-desktop_vm.edu.machines : instance.internal_ip]
# }

# output "exit_code" {
#   sensitive = true
#   value     = parallels-desktop_remote_vm.builder-2.post_processor_script[0].result[0].exit_code
# }

# output "stdout" {
#   sensitive = true
#   value     = parallels-desktop_remote_vm.builder-2.post_processor_script[0].result[0].stdout
# }
