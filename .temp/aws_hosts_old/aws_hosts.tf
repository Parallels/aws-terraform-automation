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
  tags = {
    brand              = var.aws_tag_brand,
    pillar             = var.aws_tag_pillar,
    resourceType       = var.aws_tag_resourceType,
    team               = var.aws_tag_team,
    budgetOwner        = var.aws_tag_budgetOwner,
    costCenter         = var.aws_tag_costCenter,
    productOwner       = var.aws_tag_productOwner,
    application        = var.aws_tag_application,
    businessUnit       = var.aws_tag_businessUnit,
    lifecycle          = var.aws_tag_lifecycle,
    region             = var.aws_region,
    environment        = var.aws_tag_environment,
    name               = var.aws_tag_name,
    dataClassification = var.aws_tag_dataClassification,
    iac                = var.aws_tag_iac,
    pii                = var.aws_tag_pii,
    description        = var.aws_tag_description,
  }
}

resource "aws_ec2_host" "mac" {
  count = var.machines_count

  instance_type     = var.use_intel ? "mac1.metal" : var.use_m2_pro ? "mac2-m2pro.metal" : "mac2.metal"
  availability_zone = data.aws_availability_zones.available.names[var.aws_availability_zone_index]
  host_recovery     = "off"
  auto_placement    = "on"
  tags = {
    brand              = var.aws_tag_brand,
    pillar             = var.aws_tag_pillar,
    resourceType       = var.aws_tag_resourceType,
    team               = var.aws_tag_team,
    budgetOwner        = var.aws_tag_budgetOwner,
    costCenter         = var.aws_tag_costCenter,
    productOwner       = var.aws_tag_productOwner,
    application        = var.aws_tag_application,
    businessUnit       = var.aws_tag_businessUnit,
    lifecycle          = var.aws_tag_lifecycle,
    region             = var.aws_region,
    environment        = var.aws_tag_environment,
    name               = "${substr(var.aws_region, 0, 2)}-${var.machine_base_name}.${count.index}",
    dataClassification = var.aws_tag_dataClassification,
    iac                = var.aws_tag_iac,
    pii                = var.aws_tag_pii,
    description        = var.aws_tag_description,
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

# module "vpc" {
#   source                  = "terraform-aws-modules/vpc/aws"
#   version                 = "4.0.1"
#   name                    = "${substr(var.aws_region, 0, 2)}-${var.machine_base_name}-vpc"
#   azs                     = [data.aws_availability_zones.available.names[var.aws_availability_zone_index]]
#   cidr                    = var.vpc_cidr
#   private_subnets         = var.pvc_private_subnets
#   public_subnets          = var.vpc_public_subnets
#   enable_dns_hostnames    = true
#   enable_dns_support      = true
#   map_public_ip_on_launch = true
# }

data "aws_vpc" "vpc" {
  id = "vpc-0d43dd431c88ff0f3"
}

data "aws_subnets" "subnet" {
  filter {
    name   = "vpc-id"
    values = ["vpc-0d43dd431c88ff0f3"]
  }
}

resource "aws_security_group" "ssh" {
  name        = "${substr(var.aws_region, 0, 2)}_${var.machine_base_name}-ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.aws_vpc.vpc.id
  tags = {
    brand              = var.aws_tag_brand,
    pillar             = var.aws_tag_pillar,
    resourceType       = var.aws_tag_resourceType,
    team               = var.aws_tag_team,
    budgetOwner        = var.aws_tag_budgetOwner,
    costCenter         = var.aws_tag_costCenter,
    productOwner       = var.aws_tag_productOwner,
    application        = var.aws_tag_application,
    businessUnit       = var.aws_tag_businessUnit,
    lifecycle          = var.aws_tag_lifecycle,
    region             = var.aws_region,
    environment        = var.aws_tag_environment,
    name               = var.aws_tag_name,
    dataClassification = var.aws_tag_dataClassification,
    iac                = var.aws_tag_iac,
    pii                = var.aws_tag_pii,
    description        = var.aws_tag_description,
  }

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
    description = "API Tls"
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "API Service"
    from_port   = 5005
    to_port     = 5005
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "API Service"
    from_port   = 5006
    to_port     = 5006
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

  ingress {
    description = "Ubuntu SSH"
    from_port   = 2022
    to_port     = 2022
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Ubuntu SSH"
    from_port   = 2202
    to_port     = 2202
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Ubuntu SSH1"
    from_port   = 2203
    to_port     = 2203
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP Test Route"
    from_port   = 8085
    to_port     = 8085
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Ubuntu VSCode"
    from_port   = 5589
    to_port     = 5589
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

  ami           = var.use_intel ? var.aws_ami_id_intel : var.aws_ami_id_arm
  instance_type = aws_ec2_host.mac[count.index].instance_type
  key_name      = aws_key_pair.generated_key.key_name

  availability_zone = data.aws_availability_zones.available.names[var.aws_availability_zone_index]
  host_id           = aws_ec2_host.mac[count.index].id

  subnet_id              = data.aws_subnets.subnet.ids[0]
  vpc_security_group_ids = [aws_security_group.ssh.id]

  # root_block_device {
  #   volume_size = 600
  #   delete_on_termination = true
  #   encrypted = true
  #   iops = 10000
  #   volume_type = "gp3"
  # }

  tags = {
    brand              = var.aws_tag_brand,
    pillar             = var.aws_tag_pillar,
    resourceType       = var.aws_tag_resourceType,
    team               = var.aws_tag_team,
    budgetOwner        = var.aws_tag_budgetOwner,
    costCenter         = var.aws_tag_costCenter,
    productOwner       = var.aws_tag_productOwner,
    application        = var.aws_tag_application,
    businessUnit       = var.aws_tag_businessUnit,
    lifecycle          = var.aws_tag_lifecycle,
    region             = var.aws_region,
    environment        = var.aws_tag_environment,
    name               = "${substr(var.aws_region, 0, 2)}-${var.machine_base_name}.${count.index}",
    dataClassification = var.aws_tag_dataClassification,
    iac                = var.aws_tag_iac,
    pii                = var.aws_tag_pii,
    description        = var.aws_tag_description,
  }
}

resource "time_sleep" "wait_for_instance_ready" {
  depends_on = [aws_instance.mac]

  create_duration = "360s"
}

resource "null_resource" "check_instance_ready" {
  count = var.machines_count

  depends_on = [time_sleep.wait_for_instance_ready]

  provisioner "remote-exec" {
    inline = ["echo 'Instance is ready'"]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = tls_private_key.mac.private_key_pem
      host        = aws_instance.mac[count.index].public_ip
      timeout     = "10m"
    }
  }
}
