output "primary_master" {
  value = "${local.masters_ips[0]}"
}

output "secondary_masters" {
  value = "${slice(local.masters_ips, 1, length(local.masters_ips))}"
}

output "nodes" {
  value = "${google_compute_instance.nodes.*.network_interface.0.access_config.0.nat_ip}"
}

output "lb_ip" {
  value = "${local.lb_ip}"
}
