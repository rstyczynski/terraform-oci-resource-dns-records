module "dns_records" {
  source = "../"

  zone_name_or_id = var.zone_name_or_id
  rrsets = var.rrsets
}
