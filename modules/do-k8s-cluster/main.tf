data "digitalocean_kubernetes_versions" "do-k8s-version" {
  version_prefix = var.k8s_version_prefix
}

resource "digitalocean_kubernetes_cluster" "do-k8s-cluster" {
  # Required
  name    = var.name
  region  = var.region
  version = var.auto_upgrade ? data.digitalocean_kubernetes_versions.do-k8s-version.latest_version : var.k8s_version

  # Optional
  vpc_uuid      = var.vpc_uuid
  auto_upgrade  = var.auto_upgrade
  surge_upgrade = var.surge_upgrade
  ha            = var.ha
  tags          = var.tags

  # Required Block
  node_pool {
    # Required
    name = var.node_pool.name
    size = var.node_pool.size

    # Optional
    node_count = var.node_pool.node_count
    auto_scale = var.node_pool.auto_scale
    min_nodes  = var.node_pool.min_nodes
    max_nodes  = var.node_pool.max_nodes
    tags       = var.node_pool.tags
    labels     = var.node_pool.labels

    # Optional block
    dynamic "taint" {
      for_each = lookup(var.node_pool, "taint", null) != null ? var.node_pool.taint[*] : []
      content {
        key    = taint.value.key
        value  = taint.value.value
        effect = taint.value.effect
      }
    }
  }

  # Optional block
  dynamic "maintenance_policy" {
    for_each = var.maintenance_policy != null ? var.maintenance_policy[*] : []
    iterator = mp
    content {
      day        = mp.value.day
      start_time = mp.value.start_time
    }
  }
}
