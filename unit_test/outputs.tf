output "dns_record_details" {
  description = "Created DNS Record Details."
  value       = module.dns_records.dns_record_details
}

output "domains" {
  description = "domains"
  value       = module.dns_records.domains
}
