terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

# ----------------------------------------------------
# POSTGRES IMAGE
# ----------------------------------------------------
resource "docker_image" "postgres_image" {
  name         = "postgres:latest"
  keep_locally = true
}

# ----------------------------------------------------
# POSTGRES CONTAINER
# ----------------------------------------------------
resource "docker_container" "db_container" {
  name  = "tp-db-postgres"
  image = docker_image.postgres_image.name

  ports {
    internal = 5432
    external = 5432
  }

  env = [
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}",
    "POSTGRES_DB=${var.db_name}",
  ]
}

# ----------------------------------------------------
# WEB APP IMAGE (NGINX)
# ----------------------------------------------------
resource "docker_image" "app_image" {
  name = "tp-web-app:latest"

  build {
    context    = "."
    dockerfile = "Dockerfile_app"
  }
}

# ----------------------------------------------------
# WEB APP CONTAINER
# ----------------------------------------------------
resource "docker_container" "app_container" {
  name  = "tp-app-web"
  image = docker_image.app_image.name

  depends_on = [
    docker_container.db_container
  ]

  ports {
    internal = 80
    external = var.app_port_external
  }
}
