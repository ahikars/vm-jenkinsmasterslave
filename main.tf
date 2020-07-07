provider "google" {

  version = "3.5.0"
  credentials = file(var.credentials)
  project = var.project
  region  = var.region
  zone    = var.zone

}

resource "google_compute_network" "vpc_network" {
  name = "${var.project}-vpc"
 auto_create_subnetworks = "false"
}
 
# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.project}-subnet"
  region        = var.region
  network       = google_compute_network.vpc_network.name
  ip_cidr_range = "10.10.0.0/24"

}

resource "google_compute_instance" "vm_instance" {
  name         = var.vmname
  machine_type = "n1-standard-2"
  tags         = ["web","dev","http-server"]

  boot_disk {
    initialize_params {
    #  image = "ubuntu-2004-focal-v20200609"
      image = " jenkis2"
    }
  }

# metadata_startup_script = file("./install.sh")
metadata_startup_script = ("docker start my-mail && docker start my-jenkins && sudo chmod 666 /var/run/docker.sock")

  network_interface {
    subnetwork = "${var.project}-subnet"
    subnetwork_project = var.project
    access_config {
      // Ephemeral IP
      }
    }

}


resource "google_compute_firewall" "default" {
  name    = "${var.project}-fw"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80","22","9200","5601","9090","9100","3000","50000","5001","8080","5432","5858","32768","6379"]
  }

  target_tags = ["web","dev","http-server"]
}
