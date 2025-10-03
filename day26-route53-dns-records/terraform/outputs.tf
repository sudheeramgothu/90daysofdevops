output "zone_id"    { value = local.zone_id }
output "site_fqdn"  { value = var.site_subdomain != null && var.site_subdomain != "" ? "${var.site_subdomain}.${var.domain_name}" : null }
output "alb_fqdn"   { value = var.create_alb_record ? "${var.alb_subdomain}.${var.domain_name}" : null }
