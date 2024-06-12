terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "~>5.0"
    }
  }
}

# gcp projectid_region_zone
provider "google" { 
    project = var.project-id
    region = var.region
    zone   = var.zone
  
}

# Create a Static IP
resource "google_compute_address" "static" {
  name = "ipv4-address"
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"
}


# Create a single Compute Engine instance
resource "google_compute_instance" "tf_instance" {
  name         = var.vmname
  machine_type = var.machine_type
  zone         = var.zone
  tags         = var.tags

 boot_disk {
    initialize_params {
      image = var.image
    }
  }

 network_interface {
    subnetwork = google_compute_subnetwork.default.id
    access_config {
      nat_ip = google_compute_address.static.address
    }
 }

}


