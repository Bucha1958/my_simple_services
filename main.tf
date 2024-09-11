provider "google" {
  credentials = file("mike-428601-7c6aed3dc442.json")
  project     = "mike-428601"
  region      = "us-central1"
}

resource "google_compute_network" "vpc_network" {
  name                    = "stanley-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "my_subnet" {
    name                = "test-subnetwork"
    network            = google_compute_network.vpc_network.id
    ip_cidr_range       = "10.2.0.0/16"
    region   = "us-central1"

    secondary_ip_range {
      range_name    = "gke-pods-range"
      ip_cidr_range = "10.3.0.0/16"
    }

  secondary_ip_range {
    range_name    = "gke-services-range"
    ip_cidr_range = "10.4.0.0/20"
  }
}


# GKE Cluster
resource "google_container_cluster" "primary" {
  name               = "my-gke-cluster"
  location           = "us-central1"
  network            = google_compute_network.vpc_network.id
  subnetwork         = google_compute_subnetwork.my_subnet.name
  initial_node_count = 1

  deletion_protection = false
  
  node_config {
    disk_size_gb = 50
    service_account = "okoriemmadu@mike-428601.iam.gserviceaccount.com"
    machine_type = "e2-medium"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
  
  # Enable IP Alias (optional, but recommended for GKE)
  ip_allocation_policy {
    cluster_secondary_range_name  = "gke-pods-range"
    services_secondary_range_name = "gke-services-range"
  }
}

# Output the GKE cluster name
output "cluster_name" {
  value = google_container_cluster.primary.name
}

# Optional: Outputs the cluster endpoint and CA certificate to configure kubectl
output "cluster_endpoint" {
  value = google_container_cluster.primary.endpoint
}

output "cluster_ca_certificate" {
  value = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
}


