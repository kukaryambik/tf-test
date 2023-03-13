module "kroche-dev-do-k8s-cluster" {
  source = "./modules/do-k8s-cluster"

  name               = "kroche-dev-do-k8s-cluster"
  region             = "ams3"
  k8s_version_prefix = "1.25."
  auto_upgrade       = true
  surge_upgrade      = true

  node_pool = {
    name       = "worker-pool"
    size       = "s-2vcpu-4gb"
    auto_scale = true
    min_nodes  = 1
    max_nodes  = 3
  }

  maintenance_policy = {
    start_time = "04:00"
    day        = "monday"
  }
}

provider "helm" {
  kubernetes {
    host  = module.kroche-dev-do-k8s-cluster.endpoint
    token = module.kroche-dev-do-k8s-cluster.kube_config.token
    cluster_ca_certificate = base64decode(
      module.kroche-dev-do-k8s-cluster.kube_config.cluster_ca_certificate
    )
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "argo-cd"
  version    = "~4.4.14"
  atomic     = true

  namespace        = "argocd"
  create_namespace = true

  values = [
    "${file("values.yaml")}"
  ]
}
