provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

data "local_file" "ssh_key" {
  filename = var.ssh_pub_key_path
}

resource "google_compute_instance" "general_vm" {
  count        = 2
  name         = "general-vm-${count.index + 1}"
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network       = "default"
    access_config {}
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${data.local_file.ssh_key.content}"
    enable-oslogin = "FALSE"
  }

  tags = ["general"]
}

resource "google_compute_instance_template" "mig_template" {
  name_prefix  = "mig-template"
  machine_type = "e2-medium"

  disk {
    auto_delete  = true
    boot         = true
    source_image = "debian-cloud/debian-11"
  }

  network_interface {
    network       = "default"
    access_config {}
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${data.local_file.ssh_key.content}"
    enable-oslogin = "FALSE"
  }

  tags = ["mig"]
}

resource "google_compute_region_instance_group_manager" "mig" {
  name               = "web-mig"
  region             = var.region
  base_instance_name = "mig-instance"
  target_size        = 5

  version {
    instance_template = google_compute_instance_template.mig_template.id
  }
}

resource "google_compute_firewall" "allow_ssh_http" {
  name    = "allow-ssh-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }

  target_tags = ["general", "mig"]
}
