resource "random_password" "api_key" {
  length           = 32
  special          = false
  override_special = "_%@"
}

resource "random_password" "admin_user" {
  length           = 8
  special          = false
  override_special = "_%@"
}

// This block will deploy the parallels-desktop
resource "parallels-desktop_deploy" "deploy" {
  count = var.machines_count

  api_config {
    port                   = "5005"
    log_level              = "debug"
    mode                   = "api"
    devops_version         = "0.9.12891036153-beta"
    root_password          = "6J9W67-SG4ANH-4V2BEE-6P4EJE-3D7H2X"
    enable_logging         = true
    enable_tls             = true
    tls_private_key        = "LS0tLS1CRUdJTiBQUklWQVRFIEtFWS0tLS0tCk1JSUV2Z0lCQURBTkJna3Foa2lHOXcwQkFRRUZBQVNDQktnd2dnU2tBZ0VBQW9JQkFRREQwR2hNbVphQ0ZNenQKRUdUYUhMc0NDTDRjWjZrUzQwZjQ2emIzdXJRWUNDbTBTa2plYjByVEsxNTkvRU5oajhQZzdCUHEydXJrUkZnQQpvaHI4WVB0ODBncm5uS2lmWDhIQWxZclhXR1FyZzBWQVQ4N3dEUTBLRngwTTl6SHNLdSsyT3pJT2dsQzF3TEp5CmtWZjNycUF6clRHN1Q2OU5VR1ZUdGUxbmpNN0VjV0RDemR2NE42OHlFb1lMRW5iSW1ISjRYREpudUZreTFyWHAKemJPbWVQRXVyVDFycmFTN2psRjhNU0c4UGRCU09BQ2F2OVg1aFRhdGhiamJSa3QrWGkwNWtFemhuYXBWdkRWcwpmTjIxMksrMXNabFcxN3FYR0xZYTdLSndjUHQ1MURkQlVoTUJkN2RpRUNNTkZHRTkrbDZJS0Z4UTh1QUhPZFZXCkpaWGZxb1hmQWdNQkFBRUNnZ0VBT1FjRW9TNW4wWG1hVnY1YnlOUHVPTUR3RVJpMWVsMDc5RWdZaVp4VDM5M2MKdTNlWThrTUtVU2JEemNBK3BYYTNydFZDVmJjdENvN0c3R1JKcEsvZi9qR3o0RkZWSUpsRU5jQzNuMURNVjRuVApETkJSYmNMM1JiV0dqZVNlSXZBOFFOL0xpOE16RzBQRUZLNjBwbHN5cCtvc1hpZHVYLzltaXpNa01YQ21OVHBuClExTElGMXhHemlJckpiQzYvRk5vM0RvUy94Rk5ZanNjbDZWVkhTUjl3RmhzYVZiMWhmVjlvL3ZDMEx1YzVPRVUKUGZIYzFTSlFwNkIrYTZuZlZzT1paVkExcXE0eTRnRFdMRTNGY1h3SWZrVnlKNXFKUURvcDdsM0dRQ2tvblBlZgpWSVRHdnZjbXluVzcwNklVbVRTSUdjRWZXYjgrVDkvZWc3eFlMcTNPUFFLQmdRRHI0V1ZLOFRyYis3d3hFOVB2CnhVaEIxaVY0RU9TMnBNb3lTYmU5VjcxQ3cyekRwL3BIUEx0TG9yY3hVMUFyb3NVZ2xCODk3NWFmVlZvdU1Dbi8KZDRxNnFtbzBYOHpGcWxZbUhRYjFuQzJUZC84WkxUclFkNEFlTjV3UGswd2lvSGFsbGpUZW1za08vcFJ5WXZaMAo5UGRha2tDNWhSL2IybWFlZmk4YVA5Qjlpd0tCZ1FEVWhDTHhWMmVkTnRqbVpwYzhjZGthZ0VEL3UvSjRvOVoyCnN1WGpTRGFUYmFGWVNIUXNhYnVXOUUyS0VLQ1VVbklyV0JuVHJaV0l3a3VqTHo5c3NxN0dkb2ROMFNqLytaUHgKS0N6K0NINXRMT1lXS1hURnc5V3k5N1pydlhic0E1ZU1QQUpiRkhHelh6NlVEcU9YRHIwb2owMVBFNHdKTWxDcAorZVJXTS9ETGZRS0JnUUNJL3dTa2pReGhYWWlFZkg2WUFGMmlGeXoxMmVIc0RqTjlGNEdHajZIVlY4a2dyYnZYCmlmZEJ5NFJZT29vU2ZkdTl1eW1XQUVQYjBHZXE4Y0JDcG54RlE5cWhCbzdZc3NDTUxFbXhkbjZsNm9pWFo4U0QKOVJQTStRRkRyb29HaG1uQ2JFWFNqOVY4UnZHU3FkVjRRaG96V1VRTU83d3dKVjE2YWRFVGpzS1pWd0tCZ0VBSAp1QWVEVUVLOEhjbjlxeCtaSmRLb1JlMUhrWnpyc0ZoL09taXFmMWNZTnY3RWhjeEQ1ek5xVkZwKy9BTDBmRlcyCjY4RXRrZHBzd0NGZ3dQbGROTyt6RXIxTmdjN3VRYmJ0WmZEOFdpdEcxZVJqaFQxNDdkQklkbndyejhMNHFoYWsKbGdrZk5jclhyYUVxYi91NWd5RFBYSG13NkFaMVZIeUNRRndBdGxKNUFvR0JBSnpHcVpCMXVuUEdoejIzZ3hlQgpPVTB6RmQ3WHdBSHNIeFdIUFdkbkt4c1VESkVsVkN1anJtN1hlQzNlZ25DR0MrVlhEbTBKWnIrblRyb0Y2Q01xClRyckR6NjBmYVRIRHJEeGRBd3NuK0ZMc0dHNnA0WEZOTkhMY3dRWHp2VDREYWhsNENUZjFwR3J2NVF4Z0FnN0wKbSsyODYrNWl0bUM3VGlHUGZxZ0RVaFJ3Ci0tLS0tRU5EIFBSSVZBVEUgS0VZLS0tLS0K"
    tls_certificate        = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUVGekNDQXYrZ0F3SUJBZ0lVZTNadTQrcDZ6Tk55a2VrYzlrWjVVb25ia05vd0RRWUpLb1pJaHZjTkFRRUwKQlFBd2dab3hDekFKQmdOVkJBWVRBbFZMTVJRd0VnWURWUVFJREF0WFpYTjBJRk4xYzNObGVERVFNQTRHQTFVRQpCd3dIUTNKaGQyeGxlVEVWTUJNR0ExVUVDZ3dNUTJGeWJHOXpJRXhoY0dGdk1Rc3dDUVlEVlFRTERBSkpWREVYCk1CVUdBMVVFQXd3T2JHOWpZV3d0WW5WcGJHUXVZMjh4SmpBa0Jna3Foa2lHOXcwQkNRRVdGMjV2TFhKbGNHeDUKUUd4dlkyRnNMV0oxYVd4a0xtTnZNQjRYRFRJME1URXhNakEyTWpVek9Gb1hEVEkxTVRFeE1qQTJNalV6T0ZvdwpnWm94Q3pBSkJnTlZCQVlUQWxWTE1SUXdFZ1lEVlFRSURBdFhaWE4wSUZOMWMzTmxlREVRTUE0R0ExVUVCd3dIClEzSmhkMnhsZVRFVk1CTUdBMVVFQ2d3TVEyRnliRzl6SUV4aGNHRnZNUXN3Q1FZRFZRUUxEQUpKVkRFWE1CVUcKQTFVRUF3d09iRzlqWVd3dFluVnBiR1F1WTI4eEpqQWtCZ2txaGtpRzl3MEJDUUVXRjI1dkxYSmxjR3g1UUd4dgpZMkZzTFdKMWFXeGtMbU52TUlJQklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUF3OUJvClRKbVdnaFRNN1JCazJoeTdBZ2krSEdlcEV1TkgrT3MyOTdxMEdBZ3B0RXBJM205SzB5dGVmZnhEWVkvRDRPd1QKNnRycTVFUllBS0lhL0dEN2ZOSUs1NXlvbjEvQndKV0sxMWhrSzRORlFFL084QTBOQ2hjZERQY3g3Q3J2dGpzeQpEb0pRdGNDeWNwRlg5NjZnTTYweHUwK3ZUVkJsVTdYdFo0ek94SEZnd3MzYitEZXZNaEtHQ3hKMnlKaHllRnd5Clo3aFpNdGExNmMyenBuanhMcTA5YTYya3U0NVJmREVodkQzUVVqZ0Ftci9WK1lVMnJZVzQyMFpMZmw0dE9aQk0KNFoycVZidzFiSHpkdGRpdnRiR1pWdGU2bHhpMkd1eWljSEQ3ZWRRM1FWSVRBWGUzWWhBakRSUmhQZnBlaUNoYwpVUExnQnpuVlZpV1YzNnFGM3dJREFRQUJvMU13VVRBZEJnTlZIUTRFRmdRVUpmVzlpcDdwTVVnZ2Zteko1d1YxClBIQ2tZc293SHdZRFZSMGpCQmd3Rm9BVUpmVzlpcDdwTVVnZ2Zteko1d1YxUEhDa1lzb3dEd1lEVlIwVEFRSC8KQkFVd0F3RUIvekFOQmdrcWhraUc5dzBCQVFzRkFBT0NBUUVBZ3NyYWxmbXlDU0VORVZLWDA4RXRnbTB0d1A2WQpZM1lqcjhWVkFjcVBxV0NIenlib25ub2c5SHlEbXgrSWZXUmhxV3dibkE4Z2ppYVpJOGY1QWVjeHlJTEhaMFFMCnJ0bGdwNVZIc3FDK0grUGZVdnV4eTgxNkYxNnhvK2dTWjA2TTlkSDdxdEtjcllHdzdhbEdkVkM0R2VBNVdTVW8KazZZNWRtRnE2aGZkZk13a2ZlZnR5dWJJOTJtdWdZeGpRMHc2S1ZDcUNpSk5PekJDTnlTdmZzT011MUsrWHEwUApJaGhKNG9mYjN0RWhDWEo0Mk5MNFVGRGtoKzRzUjFCNGx0UEpncWU4dGtpWVdDU2c3N0REY3I2bnkzenNDOVVKCi9SN2ZIcG91UXJLL0pOREpHQStIUW1BeUJHak9DR2Vmbk1lZmhTUUtyMGJkK0RQNzAwd2p3TExHYWc9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0t"
    tls_port               = 8443
    enable_port_forwarding = true
    environment_variables = {
      "DATABASE_SAVE_INTERVAL_MINUTES" : "3",
      "SYSTEM_RESERVED_CPU" : "2",
      "PARALLELS_DESKTOP_REFRESH_INTERVAL" : "40",
      "CATALOG_CACHE_FOLDER" : "/Users/ec2-user/cache",
    }
  }

  reverse_proxy_host {
    port = "2022"

    tcp_route {
      target_port = "22"
    }
  }

  orchestrator_registration {
    tags = [
      "test from tf3"
    ]
    description = "AWS Remote ${count.index + 1}"

    orchestrator {
      schema = "https"
      host   = "devops.local-build.co"
      port   = "443"
      authentication {
        username = "root"
        password = "Nmo5c2U1YTZycWc0Ojc4YmZkOWNlZjJmMjU0Z000"
      }
    }
  }

  ssh_connection {
    user        = "ec2-user"
    private_key = tls_private_key.mac.private_key_pem
    host        = aws_instance.mac[count.index].public_ip
    host_port   = "22"
  }

  depends_on = [
    null_resource.check_instance_ready
  ]
}

# resource "random_integer" "vnc_forward_port" {
#   min = 5900
#   max = 5999
# }

# resource "parallels-desktop_remote_vm" "builder-test" {
#   authenticator {
#     username = "root"
#     password = "Nmo5c2U1YTZycWc0Ojc4YmZkOWNlZjJmMjU0Z000"
#   }

#   orchestrator       = "https://devops.local-build.co:443"
#   name               = "code-builder-test"
#   owner              = "ec2-user"
#   catalog_id         = "ubuntu-github-action-runner"
#   version            = "v1"
#   catalog_connection = "host=root:Nmo5c2U1YTZycWc0Ojc4YmZkOWNlZjJmMjU0Z000@catalog.local-build.co"
#   path               = "/Users/ec2-user/Parallels"

#   config {
#     start_headless = true
#   }

#   force_changes = true

#   keep_running = true

#   # shared_folder {
#   #   name = "test"
#   #   path = "/Users/ec2-user/Parallels"
#   # }

#   specs {
#     cpu_count   = "3"
#     memory_size = "2048"
#   }

#   reverse_proxy_host {
#     port = random_integer.vnc_forward_port.result

#     tcp_route {
#       target_port = "22"
#     }
#   }

#   post_processor_script {
#     inline = [
#       "echo \"This is me alwaays running\"",
#     ]
#     always_run_on_update = true
#   }

#   # post_processor_script {
#   #   inline = [
#   #     "curl -o /home/install-runner.sh https://raw.githubusercontent.com/Parallels/prlctl-scripts/main/github/actions-runner/linux/install-runner.sh",
#   #     "curl -o /home/configure-runner.sh https://raw.githubusercontent.com/Parallels/prlctl-scripts/main/github/actions-runner/linux/configure-runner.sh",
#   #     "curl -o /home/remove-runner.sh https://raw.githubusercontent.com/Parallels/prlctl-scripts/main/github/actions-runner/linux/remove-runner.sh",
#   #     "chmod +x /home/install-runner.sh",
#   #     "chmod +x /home/configure-runner.sh",
#   #     "chmod +x /home/remove-runner.sh",
#   #     "/home/install-runner.sh -u parallels -p /home",
#   #     "/home/configure-runner.sh -u parallels -p /home/action-runner -o Locally-build -t ${var.github_pat_token} -n test_builder -l test_builder",
#   #   ]
#   # }

#   # on_destroy_script {
#   #   inline = [
#   #     "/home/remove-runner.sh -u parallels -p /home/action-runner -o Locally-build -t ${var.github_pat_token}"
#   #   ]
#   # }
# }

# data "parallels-desktop_vm" "edu" {
#   authenticator {
#     username = "root"
#     password = "Nmo5c2U1YTZycWc0Ojc4YmZkOWNlZjJmMjU0Z000"
#   }

#   orchestrator        = "https://devops.local-build.co:443"
#   wait_for_network_up = "false"
#   filter {
#     field_name = "name"
#     value      = "DEMO"
#   }

# }

# output "machines" {
#   value = data.parallels-desktop_vm.edu.machines
# }

# resource "parallels-desktop_vm_state" "builder-test" {
#   authenticator {
#     username = "root"
#     password = "Nmo5c2U1YTZycWc0Ojc4YmZkOWNlZjJmMjU0Z000"
#   }

#   id           = parallels-desktop_remote_vm.builder-test.id
#   orchestrator = "https://devops.local-build.co:443"
#   operation    = "stop"
#   ensure_state = true
# }

# resource "parallels-desktop_remote_vm" "builder-local" {
#   authenticator {
#     username = "root"
#     password = "Nmo5c2U1YTZycWc0Ojc4YmZkOWNlZjJmMjU0Z000"
#   }

#   host               = "http://localhost:5475"
#   name               = "code-builder"
#   owner              = "ec2-user"
#   catalog_id         = "ubuntu-github-action-runner"
#   version            = "v1"
#   catalog_connection = "host=root:Nmo5c2U1YTZycWc0Ojc4YmZkOWNlZjJmMjU0Z000@catalog.local-build.co"
#   path               = "/Users/cjlapao/Parallels"

#   config {
#     start_headless = true
#   }

#   force_changes = true

#   # shared_folder {
#   #   name = "test"
#   #   path = "/Users/ec2-user/Parallels"
#   # }

#   specs {
#     cpu_count   = "1"
#     memory_size = "2048"
#   }
# }

# resource "parallels-desktop_auth" "edu" {
#   host = "${parallels-desktop_deploy.deploy[0].api.host}:${parallels-desktop_deploy.deploy[0].api.port}"

#   api_key {
#     name   = "Terraform"
#     key    = "TerraformOps"
#     secret = random_password.api_key.result
#   }

#   claim {
#     name = "GITHUB_ACTIONS_RUNNER"
#   }

#   role {
#     name = "ADMIN"
#   }

#   user {
#     name     = "Admin User"
#     username = "admin"
#     email    = "admin@example.com"
#     password = random_password.admin_user.result
#     roles = [
#       {
#         name = "ADMIN"
#       }
#     ]
#     claims = [
#       {
#         name = "GITHUB_ACTIONS_RUNNER"
#       }
#     ]
#   }
# }

# resource "parallels-desktop_remote_vm" "builder-1" {
#   authenticator {
#     username = "root"
#     password = "Nmo5c2U1YTZycWc0Ojc4YmZkOWNlZjJmMjU0Z000"
#   }

#   orchestrator       = "https://devops.local-build.co:443"
#   name               = "code-builder"
#   owner              = "ec2-user"
#   catalog_id         = "ubuntu-github-action-runner"
#   version            = "v1"
#   catalog_connection = "host=root:Nmo5c2U1YTZycWc0Ojc4YmZkOWNlZjJmMjU0Z000@catalog.local-build.co"
#   path               = "/Users/ec2-user/Parallels"

#   config {
#     start_headless = true
#   }

#   force_changes = true

#   # shared_folder {
#   #   name = "test"
#   #   path = "/Users/ec2-user/Parallels"
#   # }

#   specs {
#     cpu_count   = "1"
#     memory_size = "2048"
#   }

#   post_processor_script {
#     inline = [
#       "curl -o /home/install-runner.sh https://raw.githubusercontent.com/Parallels/prlctl-scripts/main/github/actions-runner/linux/install-runner.sh",
#       "curl -o /home/configure-runner.sh https://raw.githubusercontent.com/Parallels/prlctl-scripts/main/github/actions-runner/linux/configure-runner.sh",
#       "curl -o /home/remove-runner.sh https://raw.githubusercontent.com/Parallels/prlctl-scripts/main/github/actions-runner/linux/remove-runner.sh",
#       "chmod +x /home/install-runner.sh",
#       "chmod +x /home/configure-runner.sh",
#       "chmod +x /home/remove-runner.sh",
#       "/home/install-runner.sh -u parallels -p /home",
#       "/home/configure-runner.sh -u parallels -p /home/action-runner -o Locally-build -t ${var.github_pat_token} -n test_builder -l test_builder",
#     ]
#   }

#   on_destroy_script {
#     inline = [
#       "/home/remove-runner.sh -u parallels -p /home/action-runner -o Locally-build -t ${var.github_pat_token}"
#     ]
#   }
# }


# resource "parallels-desktop_remote_vm" "builder-2" {
#   authenticator {
#     username = "root"
#     password = "Nmo5c2U1YTZycWc0Ojc4YmZkOWNlZjJmMjU0Z000"
#   }

#   orchestrator       = "https://devops.local-build.co:443"
#   name               = "code-builder2"
#   owner              = "ec2-user"
#   catalog_id         = "ubuntu-github-action-runner"
#   version            = "v1"
#   catalog_connection = "host=root:Nmo5c2U1YTZycWc0Ojc4YmZkOWNlZjJmMjU0Z000@catalog.local-build.co"
#   path               = "/Users/ec2-user/Parallels"

#   config {
#     start_headless = true
#   }

#   force_changes = true

#   # shared_folder {
#   #   name = "test"
#   #   path = "/Users/ec2-user/Parallels"
#   # }

#   post_processor_script {
#     environment_variables = {
#       FOO_BAR = "Foobar"
#     }

#     inline = [
#       "echo $FOO_BAR is working as expected",
#     ]
#   }

#   specs {
#     cpu_count   = "1"
#     memory_size = "2048"
#   }
# }


# resource "parallels-desktop_clone_vm" "builder2" {
#   authenticator {
#     username = "root"
#     password = "Nmo5c2U1YTZycWc0Ojc4YmZkOWNlZjJmMjU0Z000"
#   }

#   orchestrator = "https://devops.local-build.co:443"
#   name         = "code-builder-2"
#   owner        = "ec2-user"
#   base_vm_id   = "22cf8f38-9063-4802-bbf4-21379c992fdb"
#   path         = "/Users/ec2-user/Parallels"

#   config {
#     start_headless = true
#   }

#   force_changes = true

#   # post_processor_script {
#   #   inline = [
#   #     "sudo /home/parallels/install-runner.sh -o Locally-build -t ${var.github_pat_token} -p /opt -u parallels -n code-builder1 -l dotnet,linux,ubuntu",
#   #   ]
#   # }

#   # on_destroy_script {
#   #   inline = [
#   #     "sudo /home/parallels/remove-runner.sh -o Locally-build -t ${var.github_pat_token}  -p /opt -u parallels",
#   #   ]
#   # }
# }

# resource "parallels-desktop_remote_vm" "edu_builder" {
#   host            = "${parallels-desktop_deploy.deploy[0].api.host}:${parallels-desktop_deploy.deploy[0].api.port}"
#   name            = "github-builder-1"
#   owner           = "ec2-user"
#   catalog_id      = "ubuntu-github-builder"
#   version         = "v1"
#   host_connection = "host=root:Nmo5c2U1YTZycWc0Ojc4YmZkOWNlZjJmMjU0ZDQ4MjAwNWM2ZTIwYTNlMTM2@parallels.carloslapao.com"
#   path            = "/Users/ec2-user/Parallels"

#   specs {
#     cpu_count = "2"
#   }

#   force_changes = true

#   shared_folder {
#     name = "test"
#     path = "/Users/ec2-user/Parallels"
#   }

#   post_processor_script {
#     inline = [
#       "echo test6 > test.txt"
#     ]
#   }
# }

# # resource "parallels-desktop_remote_vm" "edu_builder-2" {
# #   host            = "${parallels-desktop_deploy.deploy[0].api.host}:${parallels-desktop_deploy.deploy[0].api.port}"
# #   name            = "github-builder-2"
# #   owner           = "ec2-user"
# #   catalog_id      = "ubuntu-github-builder"
# #   version         = "v1"
# #   host_connection = "host=root:Nmo5c2U1YTZycWc0Ojc4YmZkOWNlZjJmMjU0ZDQ4MjAwNWM2ZTIwYTNlMTM2@parallels.carloslapao.com"
# #   path            = "/Users/ec2-user/Parallels"

# #   specs {
# #     cpu_count = "2"
# #   }

# #   force_changes = true

# #   shared_folder {
# #     name = "test"
# #     path = "/Users/ec2-user/Parallels"
# #   }

# #   post_processor_script {
# #     inline = [
# #       "echo test6 > test.txt"
# #     ]
# #   }
# # }

# // Getting the machines from the parallels-desktop
# data "parallels-desktop_vm" "edu" {
#   host = "${parallels-desktop_deploy.deploy[0].api.host}:${parallels-desktop_deploy.deploy[0].api.port}"

#   filter {
#     field_name = "name"
#     value      = "tes"
#   }
# }

# output "machines" {
#   value = data.parallels-desktop_vm.edu.machines
# }

# # resource "parallels-desktop_packer_template" "edu" {
# #   # authenticator {
# #   #   api_key = parallels-desktop_auth.edu.api_key[0].api_key
# #   # }

# #   host     = "${parallels-desktop_deploy.deploy[0].api.host}:${parallels-desktop_deploy.deploy[0].api.port}"
# #   name     = "MacOsPacker"
# #   owner    = "ec2-user"
# #   template = "macos14_23A344_ipsw"

# # force_changes = true

# #   shared_folder {
# #     name = "testing"
# #     path = "/Users/ec2-user/sharing"
# #   }

# #   specs {
# #     cpu_count = "3"
# #   }
# # }

# data "parallels-desktop_packer_template" "edu" {
#   host = "${parallels-desktop_deploy.deploy[0].api.host}:${parallels-desktop_deploy.deploy[0].api.port}"

#   filter {
#     field_name = "name"
#     value      = "[Uu]buntu"
#   }
# }

# output "templates" {
#   value = data.parallels-desktop_packer_template.edu.templates
# }

