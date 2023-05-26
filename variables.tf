variable "aws_access_key" {
  type      = string
  sensitive = true
}

variable "aws_secret_key" {
  type      = string
  sensitive = true
}

variable "aws_region" {
  type = string
}

variable "aws_availability_zone_index" {
  type    = number
  default = 0
}


variable "script_version" {
  type    = string
  default = "1.0.0"
}

variable "aws_ami_id" {
  type    = string
  default = ""
}

variable "machines_count" {
  type    = number
  default = 1
}

variable "machine_base_name" {
  type    = string
  default = "macos"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "pvc_private_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

}

variable "vpc_public_subnets" {
  type    = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "use_intel" {
  type    = bool
  default = false
}
