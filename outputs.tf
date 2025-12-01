# --- Output : Nom du conteneur PostgreSQL ---
output "db_container_name" {
  description = "Nom du conteneur de la base de données."
  value       = docker_container.db_container.name
}

# --- Output : URL pour accéder à l'application web ---
output "app_access_url" {
  description = "URL d'accès à l'application web."
  value       = "http://localhost:${var.app_port_external}"
}
