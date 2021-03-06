create_zone                     = false
aws_domain_name                 = "ipfs-elastic-provider-aws.com"
subdomains_bitwsap_loadbalancer = "<%= expansion(':ENV.peer') %>"


# Dependency is not mapped based on outputs, so explicitly call out the dependency
# bitswap_load_balancer_dns variable will always be wrong when starting this environment from scratch. Remember to update it.
<% depends_on('peer-kubernetes-components') %>
