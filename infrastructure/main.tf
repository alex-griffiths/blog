provider "digitalocean" {
  token = var.digitalocean_token
}

resource "digitalocean_app" "blog" {
  spec {
    name   = "blog"
    region = "syd1"

    service {
      name            = "blog"
      instance_count  = 1
      instance_size_slug = "basic-xxs"
      http_port         = 8000
      dockerfile_path = "Dockerfile"
      source_dir      = "."

      github {
        branch            = "main"
        deploy_on_push    = true
        repo              = "alex-griffiths/blog"
      }

      health_check {
        http_path = "/health_check"
        initial_delay_seconds = 15
        period_seconds = 30
        failure_threshold = 4
      }
    }
  }
}