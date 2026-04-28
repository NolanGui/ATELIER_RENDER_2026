terraform {
  required_providers {
    render = {
      source  = "render-oss/render"
      version = ">= 1.7.0"
    }
  }
}

provider "render" {
  api_key  = var.render_api_key
  owner_id = var.render_owner_id
}

# --- Déclaration des variables manquantes ---
variable "render_api_key" { type = string }
variable "render_owner_id" { type = string }
variable "image_url"      { type = string }
variable "image_tag"      { type = string; default = "latest" }

variable "github_actor" {
  description = "GitHub username"
  type        = string
}

# --- Ressource corrigée ---
resource "render_web_service" "flask_app" {
  name   = "flask-render-iac-${var.github_actor}"
  plan   = "free"
  region = "frankfurt"

  runtime_source = {
    image = {
      image_url = var.image_url
      tag       = var.image_tag
    }
  }

  # IMPORTANT : Le bloc env_vars doit être ICI, à l'intérieur de la ressource
  env_vars = {
    ENV = {
      value = "production"
    }
  }
}