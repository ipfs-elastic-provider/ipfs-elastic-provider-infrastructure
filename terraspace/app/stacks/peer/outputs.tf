output "host" {
  value       = data.aws_eks_cluster.eks.endpoint
  description = "EKS control plane API server endpoint"
}

output "cluster_oidc_issuer_url" {
  value       = module.eks.cluster_oidc_issuer_url
  description = "Used for allowing Kubernetes to manage AWS resources"
}

output "cluster_id" {
  value       = module.eks.cluster_id
  description = "EKS cluster name"
}

output "cluster_ca_certificate" {
  value       = data.aws_eks_cluster.eks.certificate_authority[0].data
  description = "Base64 encoded Certificate Authority PEM for EKS"
}
