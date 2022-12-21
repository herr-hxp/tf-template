output "instance_az" {
  value = openstack_compute_instance_v2.instance_1.availability_zone
}
output "floating_ip" {
  value = openstack_networking_floatingip_v2.floatip_1.address
}
