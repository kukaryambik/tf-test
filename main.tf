terraform {
  # backend "s3" {
  #   storage_account_name = "cinditerraform"
  #   container_name       = "tfstate"
  #   key                  = "terraform.tfstate"
  # }
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}
