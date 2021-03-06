variable "create_zone" {
  type        = bool
  description = "If true, creates a managed hosted zone"
}

variable "aws_domain_name" {
  type        = string
  description = "The name of the hosted zone to either create or lookup"
}

variable "subdomains_bitwsap_loadbalancer" {
  type        = string
  description = "Subdomains that will be handled by peer svc loadbalancer"
}

variable "bitswap_load_balancer_dns" {
  type        = string
  description = "Bitswap LoadBalancer DNS. This load balancer is created and managed by Kubernetes"
}

variable "bitswap_load_balancer_hosted_zone" {
  type        = string
  description = "Bitswap LoadBalancer Hosted Zone. This load balancer is created and managed by Kubernetes"
}
