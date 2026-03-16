output "host_url" {
  value = parallels-desktop_remote_vm.github-builder-linux.host_url
}

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
