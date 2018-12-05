output "masters_ips" {
  value = "${google_compute_instance.masters.*.network_interface.0.access_config.0.nat_ip}"
}

output "nodes_ips" {
  value = "${google_compute_instance.nodes.*.network_interface.0.access_config.0.nat_ip}"
}
