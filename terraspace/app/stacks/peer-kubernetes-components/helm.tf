provider "helm" {
  kubernetes {
    host                   = var.host
    cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_id]
      command     = "aws"
    }
  }
}

resource "helm_release" "metric_server" {
  name       = "metric-server-release"
  repository = local.bitnami_repo
  chart      = "metrics-server"
  namespace  = "kube-system"
  version    = "~> 5.10"

  set {
    name  = "apiService.create"
    value = "true"
  }
}

resource "helm_release" "argocd_apps" {
  name             = "argocd-apps"
  chart            = "./helm/argocd-apps"
  namespace        = "argocd"
  create_namespace = true

  set {
    name  = "bitswapPeer.namespace"
    value = kubernetes_namespace.bitswap_peer_namespace.metadata[0].name
  }

  set {
    name  = "bitswapPeer.releaseName"
    value = kubernetes_namespace.bitswap_peer_namespace.metadata[0].name
  }

  set {
    name  = "bitswapPeer.targetRevision"
    value = var.bitswap_peer_deployment_branch
  }

  set {
    name  = "bitswapPeer.valueFileNames"
    value = "{values.yaml,values-${local.env}.yaml}"
  }

  ##fluentd export
  set {
    name  = "fluentd.namespace"
    value = kubernetes_namespace.logging_namespace.metadata[0].name
  }

  set {
    name  = "fluentd.valueFileNames"
    value = "{values.yaml,values-${local.env}.yaml}"
  }
}
