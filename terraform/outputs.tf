output "vm_1_ip" {
  value = google_compute_instance.vm_instance_1.network_interface[0].access_config[0].nat_ip
}

output "vm_2_ip" {
  value = google_compute_instance.vm_instance_2.network_interface[0].access_config[0].nat_ip
}
