output "instance_ids" {
  description = "the ids of instance"
  value       = google_compute_instance.instance[*].self_link
}
