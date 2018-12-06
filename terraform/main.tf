terraform {
  required_version = "0.11.10"
}

data "template_file" "prerequisites" {
  template = "${file("files/startup-script.sh")}"
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

  metadata {
    sshKeys = "kubeadm_demo:${file("~/.ssh/id_rsa_kubeadm_demo.pub")}"
  }

  metadata_startup_script = "${data.template_file.prerequisites.rendered}"

  boot_disk {
    initialize_params {
      image = "${var.base_image}"
    }
  }

  network_interface {
    network       = "default"
    access_config = {}
  }

  tags = ["kubernetes-master"]
}

resource "google_compute_instance" "nodes" {
  name  = "node-${count.index + 1}"
  count = 3

  machine_type = "${var.node_machine_type}"

  metadata_startup_script = "${data.template_file.prerequisites.rendered}"

  metadata {
    sshKeys = "kubeadm_demo:${file("~/.ssh/id_rsa_kubeadm_demo.pub")}"
  }

  boot_disk {
    initialize_params {
      image = "${var.base_image}"
    }
  }

  network_interface {
    network       = "default"
    access_config = {}
  }

  tags = ["kubernetes-node"]
}

resource "google_compute_target_pool" "masters" {
  name      = "masters"
  instances = ["${google_compute_instance.masters.*.self_link}"]
}

resource "google_compute_forwarding_rule" "masters" {
  name   = "masters"
  target = "${google_compute_target_pool.masters.self_link}"
}

locals {
  masters_ips = "${google_compute_instance.masters.*.network_interface.0.access_config.0.nat_ip}"
  lb_ip       = "${google_compute_forwarding_rule.masters.ip_address}"
}

resource "google_compute_firewall" "masters" {
  name    = "default-allow-masters"
  network = "default"

  allow {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
}

data "template_file" "kubeadm_config" {
  template = "${file("templates/kubeadm-config.yml")}"

  vars {
    lb_address = "${local.lb_ip}"
    master_0   = "${local.masters_ips[0]}"
    master_1   = "${local.masters_ips[1]}"
    master_2   = "${local.masters_ips[2]}"
  }
}

data "template_file" "copy_certs" {
  template = "${file("templates/copy_certs.sh")}"

  vars {
    secondary_masters = "(${join(" ", slice(local.masters_ips, 1, length(local.masters_ips)))})"
  }
}

resource "null_resource" "generate_scripts" {
  connection {
    host        = "${local.masters_ips[0]}"
    private_key = "${file("~/.ssh/id_rsa_kubeadm_demo")}"
    user        = "kubeadm_demo"
  }

  provisioner "file" {
    content     = "${data.template_file.kubeadm_config.rendered}"
    destination = "/home/kubeadm_demo/kubeadm-config.yml"
  }

  provisioner "file" {
    content     = "${data.template_file.copy_certs.rendered}"
    destination = "/home/kubeadm_demo/copy_certs.sh"
  }
}
