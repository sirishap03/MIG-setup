output "general_vm_ips" {
  value = google_compute_instance.general_vm[*].network_interface[0].access_config[0].nat_ip
}
