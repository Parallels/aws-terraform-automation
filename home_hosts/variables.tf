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

variable "intel_mac_password" {
  type      = string
  sensitive = true
}

variable "intel_mac_host" {
  type = string
}

variable "intel_mac_port" {
  type = number
}

variable "intel_mac_user" {
  type = string
}
