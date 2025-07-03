module "dns_records" {
  source = "./module"

  zone_name_or_id = var.zone_name_or_id
  rrsets          = var.rrsets
}
