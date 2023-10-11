data "aws_availability_zones" "available" {
  state = "available"
}

resource "tls_private_key" "mac" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "${var.machine_base_name}-terraform"
  public_key = tls_private_key.mac.public_key_openssh
}

resource "aws_ec2_host" "mac" {
  count = var.machines_count

  instance_type     = var.use_intel ? "mac1.metal" : var.use_m2_pro ? "mac2-m2pro.metal" : "mac2.metal"
  availability_zone = data.aws_availability_zones.available.names[var.aws_availability_zone_index]
  host_recovery     = "off"
  auto_placement    = "on"
  tags = {
    Name = "${substr(var.aws_region, 0, 2)}-${var.machine_base_name}.${count.index}"
  }
}

data "aws_ami" "mac" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["*mac*"]
  }

  filter {
    name   = "architecture"
    values = ["arm*"]
  }
}

module "vpc" {
  source                  = "terraform-aws-modules/vpc/aws"
  version                 = "4.0.1"
  name                    = "${substr(var.aws_region, 0, 2)}-${var.machine_base_name}-vpc"
  azs                     = [data.aws_availability_zones.available.names[var.aws_availability_zone_index]]
  cidr                    = var.vpc_cidr
  private_subnets         = var.pvc_private_subnets
  public_subnets          = var.vpc_public_subnets
  enable_dns_hostnames    = true
  enable_dns_support      = true
  map_public_ip_on_launch = true
}

resource "aws_security_group" "ssh" {
  name        = "${substr(var.aws_region, 0, 2)}_${var.machine_base_name}-ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from VPC"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "VNC from VPC"
    from_port   = 5900
    to_port     = 5900
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "mac" {
  count = var.machines_count

  ami           = var.aws_ami_id == "" ? data.aws_ami.mac.id : var.aws_ami_id
  instance_type = aws_ec2_host.mac[count.index].instance_type
  key_name      = aws_key_pair.generated_key.key_name

  availability_zone = data.aws_availability_zones.available.names[var.aws_availability_zone_index]
  host_id           = aws_ec2_host.mac[count.index].id

  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.ssh.id]
  tags = {
    Name = "${substr(var.aws_region, 0, 2)}-${var.machine_base_name}.${count.index}"
  }
}

resource "time_sleep" "wait_120_seconds" {
  depends_on = [aws_instance.mac]

  create_duration = "120s"
}

resource "terraform_data" "init_script" {
  count = var.machines_count

  triggers_replace = {
    file_hash = md5(file("./scripts/init.sh"))
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.mac.private_key_pem
    host        = aws_instance.mac[count.index].public_ip
  }

  provisioner "remote-exec" {
    script = "./scripts/init.sh"
  }

  depends_on = [
    time_sleep.wait_120_seconds
  ]
}

resource "terraform_data" "install_parallels_desktop" {
  count = var.install_parallels_desktop ? var.machines_count : 0

  triggers_replace = {
    file_hash = md5(file("./scripts/install-parallels-desktop.sh"))
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.mac.private_key_pem
    host        = aws_instance.mac[count.index].public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "if [ -f ~/export.sh ]; then rm -f ~/export.sh; fi",
      "echo \"export PARALLELS_KEY=${var.parallels_key}\" >> ~/export.sh",
      "echo \"export PARALLELS_USER_EMAIL=${var.parallels_user_email}\" >> ~/export.sh",
      "echo \"export PARALLELS_USER_PASSWORD=${var.parallels_user_password}\" >> ~/export.sh",
    ]
  }

  provisioner "remote-exec" {
    script = "./scripts/install-parallels-desktop.sh"
  }

  depends_on = [
    terraform_data.init_script
  ]
}

resource "terraform_data" "vnc_enable" {
  count = var.enable_vnc ? var.machines_count : 0

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.mac.private_key_pem
    host        = aws_instance.mac[count.index].public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "if [ -f ~/export.sh ]; then rm -f ~/export.sh; fi",
      "echo \"export VNC_USER_PASSWORD=${var.vnc_user_password}\" >> ~/export.sh",
    ]
  }

  provisioner "remote-exec" {
    script = "./scripts/enable-vnc.sh"
  }

  depends_on = [
    terraform_data.init_script
  ]
}

resource "terraform_data" "ubuntu" {
  count = var.install_parallels_desktop ? var.machines_count : 0

  triggers_replace = [
    var.ubuntu_machines_count
  ]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.mac.private_key_pem
    host        = aws_instance.mac[count.index].public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "if [ -f ~/export.sh ]; then rm -f ~/export.sh; fi",
      "echo \"export MACHINE_COUNT=${var.ubuntu_machines_count}\" >> ~/export.sh",
      "echo \"export MACHINE_NAME=${var.ubuntu_machine_name != "" ? "${replace(var.ubuntu_machine_name, " ", "\\ ")}" : "Ubuntu"}\" >> ~/export.sh",
      "echo \"export UBUNTU_VERSION=${var.ubuntu_machine_os_version}\" >> ~/export.sh",
      "echo \"export CPU_COUNT=${var.ubuntu_machine_cpu_count}\" >> ~/export.sh",
      "echo \"export MEM_SIZE=${var.ubuntu_machine_mem_size}\" >> ~/export.sh",
      "echo \"export DISK_SIZE=${var.ubuntu_machine_disk_size}\" >> ~/export.sh",
    ]
  }

  provisioner "remote-exec" {
    script = "./scripts/create-ubuntu-vm.sh"
  }

  depends_on = [
    terraform_data.install_parallels_desktop
  ]
}

resource "terraform_data" "macos" {
  count = var.install_parallels_desktop ? var.machines_count : 0

  triggers_replace = [
    var.macos_machines_count
  ]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.mac.private_key_pem
    host        = aws_instance.mac[count.index].public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "if [ -f ~/export.sh ]; then rm -f ~/export.sh; fi",
      "echo \"export MACHINE_COUNT=${var.macos_machines_count}\" >> ~/export.sh",
      "echo \"export MACHINE_NAME=${var.macos_machine_name != "" ? "${replace(var.macos_machine_name, " ", "\\ ")}" : "macOS"}\" >> ~/export.sh",
      "echo \"export IPSW_URL=${var.macos_ipsw_url}\" >> ~/export.sh",
      "echo \"export IPSW_CHECKSUM=${var.macos_ipsw_checksum}\" >> ~/export.sh",
    ]
  }

  provisioner "remote-exec" {
    script = "./scripts/create-macos-vm.sh"
  }

  depends_on = [
    terraform_data.install_parallels_desktop
  ]
}

