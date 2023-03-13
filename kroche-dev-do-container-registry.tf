resource "digitalocean_container_registry" "kroche-dev" {
  name                   = "kroche-dev"
  subscription_tier_slug = "starter"
  region                 = "ams3"
}
