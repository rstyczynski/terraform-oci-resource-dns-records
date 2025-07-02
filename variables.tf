variable "zone_name_or_id" {
  description = "The name or OCID of the target zone."
  type        = string
}

variable "rrsets" {
  description = "List of DNS rrsets. Each record set must specify the domain and rtype, and a list of items. NOTE: Omitting items at time of create will delete any existing records in the RRSet. Default is empty list."
  type = list(object({
    domain = string
    rtype  = string
    records  = list(object({
      domain = string
      rtype  = optional(string, "A")
      rdata = string
      ttl   = optional(number, 300)
    }))
  }))
  
  default = []

  validation {
    condition     = length(var.rrsets) <= 50
    error_message = "The number of DNS records must not exceed 20."
  }
}

