output "dns_record_details" {
  description = "Created DNS Record Details."
  value       = module.dns_records.dns_record_details
}

output "domains" {
  description = "domains with index to match failing record when necessary."
  value = [
    for idx, domain in module.dns_records.domains : "${idx}: ${domain}"
  ]
}
