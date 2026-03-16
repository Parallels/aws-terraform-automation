variable "aws_access_key_id" {
  type      = string
  sensitive = true
}

variable "aws_secret_access_key" {
  type      = string
  sensitive = true
}

variable "aws_session_token" {
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

variable "aws_ami_id_arm" {
  type    = string
  default = "ami-06844debf2367c8a2" #Arm Version sequoia 
}

variable "aws_ami_id_intel" {
  type    = string
  default = "ami-06844debf2367c8a2" #Arm Version sequoia 
}

variable "machines" {
  type = list(object({
    instance_type = string
    instance_name = string
    use_intel     = bool
    use_m2_pro    = bool
    ami_id        = string
  }))

  default = []
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

variable "use_m2_pro" {
  type    = bool
  default = false
}

variable "parallels_key" {
  type      = string
  sensitive = true
}

variable "github_org_url" {
  type      = string
  sensitive = true
}

variable "github_pat_token" {
  type      = string
  sensitive = true
}

variable "aws_tag_brand" {
  type    = string
  default = "parallels"
}

variable "aws_tag_pillar" {
  type    = string
  default = "tech"
}

variable "aws_tag_resourceType" {
  type    = string
  default = "instance"
}

variable "aws_tag_team" {
  type    = string
  default = "carloslapao"
}

variable "aws_tag_budgetOwner" {
  type    = string
  default = "RD5000"
}

variable "aws_tag_costCenter" {
  type    = string
  default = "RD5000"
}

variable "aws_tag_productOwner" {
  type    = string
  default = "Carlos Lapao"
}

variable "aws_tag_application" {
  type    = string
  default = "DevOps Service"
}

variable "aws_tag_businessUnit" {
  type    = string
  default = "Parallels"
}

variable "aws_tag_lifecycle" {
  type    = string
  default = "active"
}

variable "aws_tag_environment" {
  type    = string
  default = "test"
}

variable "aws_tag_name" {
  type    = string
  default = "DevOps MacOS Host"
}

variable "aws_tag_" {
  type    = string
  default = ""
}

variable "aws_tag_dataClassification" {
  type    = string
  default = "nada"
}

variable "aws_tag_iac" {
  type    = string
  default = "terraform"
}

variable "aws_tag_pii" {
  type    = string
  default = "no"
}

variable "aws_tag_description" {
  type    = string
  default = "Apple Mac Mini Host for development and testing of different stages of the open source app DevOps Service"
}
