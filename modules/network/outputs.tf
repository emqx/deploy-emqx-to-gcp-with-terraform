output "network" {
  description = "the name of network"
  value       = google_compute_network.vnet.name
}

output "subnetwork" {
  description = "the name of emqx subnetwork"
  value = [for sn in google_compute_subnetwork.sn : sn.name]
}
