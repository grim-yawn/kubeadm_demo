terraform {
  required_version = "0.11.10"
}

provider "google" {
  version = "1.19"

  project = "${var.project_id}"
  region  = "europe-west4"
  zone    = "europe-west4-a"
}

resource "google_compute_instance" "masters" {
  name  = "master-${count.index + 1}"
  count = 3

  machine_type = "${var.master_machine_type}"

  boot_disk {
    initialize_params {
      image = "${var.base_image}"
    }
  }

  network_interface {
    network       = "default"
    access_config = {}
  }
}

resource "google_compute_instance" "nodes" {
  name  = "node-${count.index + 1}"
  count = 3

  machine_type = "${var.node_machine_type}"

  boot_disk {
    initialize_params {
      image = "${var.base_image}"
    }
  }

  network_interface {
    network       = "default"
    access_config = {}
  }
}
