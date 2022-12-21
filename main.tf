## PROVIDER
# Configure the OpenStack Provider
provider "openstack" {
  # Use your .rc file instead by sourcing it
  #user_name          = "" # use $OS_USERNAME
  #tenant_name        = "" # use $OS_PROJECT_NAME
  #tenant_id          = "" # use $OS_PROJECT_ID
  #password           = "" # use $OS_PASSWORD
  #auth_url           = "" # use $OS_AUTH_URL
  #region             = "" # use $OS_REGION_NAME
}

## NETWORK
# Create network
resource "openstack_networking_network_v2" "network_1" {
  name                = var.network_name
  admin_state_up      = "true"
}

# Create subnet
resource "openstack_networking_subnet_v2" "subnet_1" {
  name                = var.subnet_name
  network_id          = "${openstack_networking_network_v2.network_1.id}"
  cidr                = var.subnet_cidr
  ip_version          = 4
  dns_nameservers     = var.dns_ips
}

# Create router
# Needed for a clean project instead of the below connection to an existing router
resource "openstack_networking_router_v2" "router_1" {
  name                = var.router_name
  external_network_id = var.external_network_id
}

# Connect the subnet to the router
resource "openstack_networking_router_interface_v2" "router_interface_1" {
  router_id           = "${openstack_networking_router_v2.router_1.id}"
  subnet_id           = "${openstack_networking_subnet_v2.subnet_1.id}"
}

## Create Security Groups
# HTTP(S)
resource "openstack_networking_secgroup_v2" "web_sg" {
  name                = var.sg1_name
  description         = var.sg1_desc
}

# SSH
resource "openstack_networking_secgroup_v2" "ssh_sg" {
  name                = var.sg2_name
  description         = var.sg2_desc
}

## Create Security Group Rules
# Port 80
#+ Do we need port 80?
resource "openstack_networking_secgroup_rule_v2" "http_rule" {
  direction           = "ingress"
  ethertype           = "IPv4"
  protocol            = "tcp"
  port_range_min      = 80
  port_range_max      = 80
  remote_ip_prefix    = "0.0.0.0/0" # Lock down external access?
  security_group_id   = "${openstack_networking_secgroup_v2.web_sg.id}"
}

# Port 443
resource "openstack_networking_secgroup_rule_v2" "https_rule" {
  direction           = "ingress"
  ethertype           = "IPv4"
  protocol            = "tcp"
  port_range_min      = 443
  port_range_max      = 443
  remote_ip_prefix    = "0.0.0.0/0" # Lock dock external access?
  security_group_id   = "${openstack_networking_secgroup_v2.web_sg.id}"
}

# Port 22
resource "openstack_networking_secgroup_rule_v2" "ssh_rule" {
  direction           = "ingress"
  ethertype           = "IPv4"
  protocol            = "tcp"
  port_range_min      = 22
  port_range_max      = 22
  remote_ip_prefix    = "0.0.0.0/0" # From where should we allow SSH access? For demo purposes 0.0.0.0 is fine, but modify this after your needs
  security_group_id   = "${openstack_networking_secgroup_v2.ssh_sg.id}"
}

## Create ports
# Make a list of IPs in variables
resource "openstack_networking_port_v2" "port_1" {
  name                = "port_1"
  network_id          = "${openstack_networking_network_v2.network_1.id}"
  admin_state_up      = "true"
  security_group_ids  = ["${openstack_networking_secgroup_v2.web_sg.id}","${openstack_networking_secgroup_v2.ssh_sg.id}"]

  fixed_ip {
    subnet_id         = "${openstack_networking_subnet_v2.subnet_1.id}"
    ip_address        = var.port_ip
  }
}


## INSTANCE(S)
# Create server group
resource "openstack_compute_servergroup_v2" "srvgrp" {
  name                = var.servergroup_name
  policies            = ["soft-anti-affinity"]
}

# Create instance(s)
resource "openstack_compute_instance_v2" "instance_1" {
  name                = var.instance_name
  #count              = 1 # We can use this to create more than 1 instance
  #name               = "server-${count.index+1}" # use this name if we have more than 1
  image_id            = var.image_id
  flavor_name         = var.flavor_name
  key_pair            = var.key_name
  network {
    port              = openstack_networking_port_v2.port_1.id
  }
  scheduler_hints {
    group             = openstack_compute_servergroup_v2.srvgrp.id
  } 
  depends_on          = [openstack_networking_subnet_v2.subnet_1]
}

# Fetch Floating IP
resource "openstack_networking_floatingip_v2" "floatip_1" {
  pool                = var.fip_pool
}

# Associate Floating IP to the Instance Port
resource "openstack_networking_floatingip_associate_v2" "fip_1" {
  floating_ip         = "${openstack_networking_floatingip_v2.floatip_1.address}"
#  instance_id         = "${openstack_compute_instance_v2.instance_1.id}"
  port_id            = "${openstack_networking_port_v2.port_1.id}"
}
