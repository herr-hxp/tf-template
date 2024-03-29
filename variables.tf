## VARIABLES
# Make changes here

## KEY
# Change this to your actual key in OpenStack
variable "key_name" {
  type    = string
  default = "<your key name here>"
}

## Network Variables
# Network
variable "network_name" {
  type    = string
  default = "demo_network"
}

# Subnet
variable "subnet_name" {
  type    = string
  default = "demo_subnet"
}

variable "subnet_cidr" {
  type    = string
  default = "192.168.10.0/24"
}

variable "port_ip" {
  type    = string
  default = "192.168.10.50"
}

# DNS
variable "dns_ips" {
  type    = list(string)
  default = ["8.8.8.8", "8.8.4.4", "1.1.1.1"]
}

# Router
variable "router_name" {
  type    = string
  default = "demo_router"
}

# Used if you already have an existing router
variable "router_id" {
  type    = string
  default = "<router id>"
}

# Security Groups
variable "sg1_name" {
  type    = string
  default = "demo HTTP(S)"
}

variable "sg1_desc" {
  type    = string
  default = "demo SG for Port 80 and 443"
}

variable "sg2_name" {
  type    = string
  default = "demo SSH"
}

variable "sg2_desc" {
  type    = string
  default = "demo SG for Port 22"
}

## Instance Variables

# Server Group
variable "servergroup_name" {
  type    = string
  default = "demo_servergroup"
}

# Instance
variable "instance_name" {
  type    = string
  default = "demoserver"
}

variable "image_id" {
  type    = string
  default = "bbf26e02-ba0c-4086-8df3-d169687d7393"
}

variable "flavor_name" {
  type    = string
  default = "v1-standard-2"
}

variable "region" {
  type    = string
  default = "sto1"
}

# Floating IP
variable "fip_pool" {
  type    = string
  default = "elx-public1"
}
