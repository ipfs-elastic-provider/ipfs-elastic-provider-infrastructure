variable "domain_name" {
  type = string
  # default = "aws-ipfs.com"
  default = "franciscocardosotest.com"
}

variable "subdomains_bitwsap_loadbalancer" {
  default = "peer"
  description = "Subdomains that will be handled by peer svc loadbalancer"
}

variable "subdomains_provider_loadbalancer" {
  default = "provider"
  description = "Subdomains that will be handled by provider svc loadbalancer"
}

variable "subdomain_apis" {
  type = string
  default = "api.uploader"
  description = "Name for a API Gateway subdomain"
}
