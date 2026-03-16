resource "random_integer" "vnc_forward_port" {
  min = 5900
  max = 5999
}

resource "parallels-desktop_remote_vm" "github-builder-linux" {
  authenticator {
    username = "root"
    password = "Nmo5c2U1YTZycWc0Ojc4YmZkOWNlZjJmMjU0Z000"
  }

  orchestrator       = "https://devops.local-build.co"
  name               = "code-builder-linux"
  owner              = "ec2-user"
  catalog_id         = "MACOS15-SPARSE-COMPRESSION"
  version            = "21de185744bf519e687cdf12f62b1c741371cdfa5e747b029056710e5b8c57fe-1"
  catalog_connection = "host=root:Nmo5c2U1YTZycWc0Ojc4YmZkOWNlZjJmMjU0Z000@catalog.local-build.co"
  path               = "/Users/ec2-user/Parallels"

  config {
    start_headless = true
  }

  force_changes = true

  keep_running = true

  # shared_folder {
  #   name = "test"
  #   path = "/Users/ec2-user/Parallels"
  # }

  specs {
    cpu_count   = "3"
    memory_size = "2048"
  }

  reverse_proxy_host {
    port = random_integer.vnc_forward_port.result

    tcp_route {
      target_port = "22"
    }
  }

  post_processor_script {
    inline = [
      "echo \"This is me always running\"",
    ]
    always_run_on_update = true
  }

  # post_processor_script {
  #   inline = [
  #     "curl -o /home/install-runner.sh https://raw.githubusercontent.com/Parallels/prlctl-scripts/main/github/actions-runner/linux/install-runner.sh",
  #     "curl -o /home/configure-runner.sh https://raw.githubusercontent.com/Parallels/prlctl-scripts/main/github/actions-runner/linux/configure-runner.sh",
  #     "curl -o /home/remove-runner.sh https://raw.githubusercontent.com/Parallels/prlctl-scripts/main/github/actions-runner/linux/remove-runner.sh",
  #     "chmod +x /home/install-runner.sh",
  #     "chmod +x /home/configure-runner.sh",
  #     "chmod +x /home/remove-runner.sh",
  #     "/home/install-runner.sh -u parallels -p /home",
  #     "/home/configure-runner.sh -u parallels -p /home/action-runner -o Locally-build -t ${var.github_pat_token} -n test_builder -l test_builder",
  #   ]
  # }

  # on_destroy_script {
  #   inline = [
  #     "/home/remove-runner.sh -u parallels -p /home/action-runner -o Locally-build -t ${var.github_pat_token}"
  #   ]
  # }
}

resource "parallels-desktop_vm_state" "vm" {
  authenticator {
    username = "root"
    password = "Nmo5c2U1YTZycWc0Ojc4YmZkOWNlZjJmMjU0Z000"
  }

  id           = parallels-desktop_remote_vm.github-builder-linux.id
  orchestrator = "http://hosts.local-build.co:5690"
  operation    = "stop"
  ensure_state = true
}

# data "parallels-desktop_vm" "edu" {
#   authenticator {
#     username = "root"
#     password = "Nmo5c2U1YTZycWc0Ojc4YmZkOWNlZjJmMjU0Z000"
#   }

#   orchestrator        = "http://hosts.local-build.co:5690"
#   wait_for_network_up = "false"
#   filter {
#     field_name = "name"
#     value      = "DEMO"
#   }
# }

# resource "parallels-desktop_vm_state" "vm" {
#   authenticator {
#     username = "root"
#     password = "Nmo5c2U1YTZycWc0Ojc4YmZkOWNlZjJmMjU0Z000"
#   }

#   id           = parallels-desktop_remote_vm.github-builder-linux.id
#   orchestrator = "http://hosts.local-build.co:5690"
#   operation    = "start"
#   ensure_state = true
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

