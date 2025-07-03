
variable "zone_name_or_id" {
  description = "The OCID or name of the DNS zone to manage records in."
  type        = string
}

variable "rrsets" {
  description = "Map of DNS rrsets keyed by FQDN aka domain. Each value must specify the rtype and a list of records. NOTE: Omitting items at time of create will delete any existing records in the RRSet. Default is empty map."
  type = map(object({
    rtype = optional(string, "A")
    ttl   = optional(number, 300)
    records = list(object({
      rtype = optional(string)
      rdata = string
      ttl   = optional(number)
    }))
  }))

  validation {
    condition     = length(keys(var.rrsets)) <= 50
    error_message = "The number of DNS records must not exceed 50."
  }
}
