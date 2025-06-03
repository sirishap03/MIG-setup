provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# -------------------------
# Create 2 Standalone VMs
# -------------------------
resource "google_compute_instance" "vm_instance_1" {
  name         = "general-vm-1"
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

  tags = ["general"]
}

resource "google_compute_instance" "vm_instance_2" {
  name         = "general-vm-2"
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

  tags = ["general"]
}

# -------------------------
# Instance Template for MIG (NO startup script)
# -------------------------
resource "google_compute_instance_template" "mig_template" {
  name_prefix   = "mig-template"
  machine_type  = "e2-medium"

  disk {
    auto_delete  = true
    boot         = true
    source_image = "debian-cloud/debian-11"
  }

  network_interface {
    network       = "default"
    access_config {}
  }

  tags = ["mig"]
}

# -------------------------
# MIG with 5 Instances
# -------------------------
resource "google_compute_region_instance_group_manager" "mig" {
  name               = "web-mig"
  region             = var.region
  base_instance_name = "mig-vm"
  target_size        = 5

  version {
    instance_template = google_compute_instance_template.mig_template.id
  }
}

# -------------------------
# Allow SSH and HTTP (for later Apache)
# -------------------------
resource "google_compute_firewall" "allow_http_ssh" {
  name    = "allow-http-ssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }

  target_tags = ["general", "mig"]
}
