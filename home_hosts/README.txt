```hcl
resource "parallels-desktop_vagrant_box" "edu" {
  host     = "${parallels-desktop_deploy.deploy[0].api.host}:${parallels-desktop_deploy.deploy[0].api.port}"
  name     = "Test Vagrant"
  owner    = "ec2-user"
  box_name = "dcagatay/fedora-39b-aarch64"

  force_changes = true

  specs {
    cpu_count   = "2"
  }

  shared_folder {
    name = "testing"
    path = "/Users/ec2-user/sharing"
  }

  post_processor_script {
    inline = [
      "ls -la",
      "echo test1 > test.txt"
    ]
  }

  post_processor_script {
    inline = [
      "ls"
    ]
  }

}
```

```hcl
# resource "parallels-desktop_vagrant_box" "edu-1" {
#   host     = "${parallels-desktop_deploy.deploy[0].api.host}:${parallels-desktop_deploy.deploy[0].api.port}"
#   name     = "Test Vagrant File"
#   owner    = "ec2-user"
#   vagrant_file_path = "/Users/ec2-user/VagrantTest/Vagrantfile"

#   force_changes = true
# }
```