
locals {
  zone_name_or_id = var.zone_name_or_id
  rrsets          = var.rrsets

  domains = [for k in keys(local.rrsets) : k]
}

resource "oci_dns_rrset" "no_0" {
  count           = length(local.domains) > 0 ? 1 : 0

  domain          = local.domains[0]
  rtype           = local.rrsets[local.domains[0]].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[local.domains[0]].records
    content {
      domain = local.domains[0]
      rdata  = items.value.rdata
      rtype  = coalesce(items.value.rtype, local.rrsets[local.domains[0]].rtype)
      ttl    = coalesce(items.value.ttl, local.rrsets[local.domains[0]].ttl)
    }
  }
}

resource "oci_dns_rrset" "no_1" {
  count           = length(local.domains) > 1 ? 1 : 0

  domain          = local.domains[1]
  rtype           = local.rrsets[local.domains[1]].rtype
  zone_name_or_id = local.zone_name_or_id

depends_on = [oci_dns_rrset.no_0]

  dynamic "items" {
    for_each = local.rrsets[local.domains[1]].records
    content {
      domain = local.domains[1]
      rdata  = items.value.rdata
      rtype  = coalesce(items.value.rtype, local.rrsets[local.domains[1]].rtype)
      ttl    = coalesce(items.value.ttl, local.rrsets[local.domains[1]].ttl)
    }
  }
}

resource "oci_dns_rrset" "no_2" {
  count           = length(local.domains) > 2 ? 1 : 0

  domain          = local.domains[2]
  rtype           = local.rrsets[local.domains[2]].rtype
  zone_name_or_id = local.zone_name_or_id

depends_on = [oci_dns_rrset.no_1]

  dynamic "items" {
    for_each = local.rrsets[local.domains[2]].records
    content {
      domain = local.domains[2]
      rdata  = items.value.rdata
      rtype  = coalesce(items.value.rtype, local.rrsets[local.domains[2]].rtype)
      ttl    = coalesce(items.value.ttl, local.rrsets[local.domains[2]].ttl)
    }
  }
}

resource "oci_dns_rrset" "no_3" {
  count           = length(local.domains) > 3 ? 1 : 0

  domain          = local.domains[3]
  rtype           = local.rrsets[local.domains[3]].rtype
  zone_name_or_id = local.zone_name_or_id

depends_on = [oci_dns_rrset.no_2]

  dynamic "items" {
    for_each = local.rrsets[local.domains[3]].records
    content {
      domain = local.domains[3]
      rdata  = items.value.rdata
      rtype  = coalesce(items.value.rtype, local.rrsets[local.domains[3]].rtype)
      ttl    = coalesce(items.value.ttl, local.rrsets[local.domains[3]].ttl)
    }
  }
}

resource "oci_dns_rrset" "no_4" {
  count           = length(local.domains) > 4 ? 1 : 0

  domain          = local.domains[4]
  rtype           = local.rrsets[local.domains[4]].rtype
  zone_name_or_id = local.zone_name_or_id

depends_on = [oci_dns_rrset.no_3]

  dynamic "items" {
    for_each = local.rrsets[local.domains[4]].records
    content {
      domain = local.domains[4]
      rdata  = items.value.rdata
      rtype  = coalesce(items.value.rtype, local.rrsets[local.domains[4]].rtype)
      ttl    = coalesce(items.value.ttl, local.rrsets[local.domains[4]].ttl)
    }
  }
}

resource "oci_dns_rrset" "no_5" {
  count           = length(local.domains) > 5 ? 1 : 0

  domain          = local.domains[5]
  rtype           = local.rrsets[local.domains[5]].rtype
  zone_name_or_id = local.zone_name_or_id

depends_on = [oci_dns_rrset.no_4]

  dynamic "items" {
    for_each = local.rrsets[local.domains[5]].records
    content {
      domain = local.domains[5]
      rdata  = items.value.rdata
      rtype  = coalesce(items.value.rtype, local.rrsets[local.domains[5]].rtype)
      ttl    = coalesce(items.value.ttl, local.rrsets[local.domains[5]].ttl)
    }
  }
}

resource "oci_dns_rrset" "no_6" {
  count           = length(local.domains) > 6 ? 1 : 0

  domain          = local.domains[6]
  rtype           = local.rrsets[local.domains[6]].rtype
  zone_name_or_id = local.zone_name_or_id

depends_on = [oci_dns_rrset.no_5]

  dynamic "items" {
    for_each = local.rrsets[local.domains[6]].records
    content {
      domain = local.domains[6]
      rdata  = items.value.rdata
      rtype  = coalesce(items.value.rtype, local.rrsets[local.domains[6]].rtype)
      ttl    = coalesce(items.value.ttl, local.rrsets[local.domains[6]].ttl)
    }
  }
}

resource "oci_dns_rrset" "no_7" {
  count           = length(local.domains) > 7 ? 1 : 0

  domain          = local.domains[7]
  rtype           = local.rrsets[local.domains[7]].rtype
  zone_name_or_id = local.zone_name_or_id

depends_on = [oci_dns_rrset.no_6]

  dynamic "items" {
    for_each = local.rrsets[local.domains[7]].records
    content {
      domain = local.domains[7]
      rdata  = items.value.rdata
      rtype  = coalesce(items.value.rtype, local.rrsets[local.domains[7]].rtype)
      ttl    = coalesce(items.value.ttl, local.rrsets[local.domains[7]].ttl)
    }
  }
}

resource "oci_dns_rrset" "no_8" {
  count           = length(local.domains) > 8 ? 1 : 0

  domain          = local.domains[8]
  rtype           = local.rrsets[local.domains[8]].rtype
  zone_name_or_id = local.zone_name_or_id

depends_on = [oci_dns_rrset.no_7]

  dynamic "items" {
    for_each = local.rrsets[local.domains[8]].records
    content {
      domain = local.domains[8]
      rdata  = items.value.rdata
      rtype  = coalesce(items.value.rtype, local.rrsets[local.domains[8]].rtype)
      ttl    = coalesce(items.value.ttl, local.rrsets[local.domains[8]].ttl)
    }
  }
}

resource "oci_dns_rrset" "no_9" {
  count           = length(local.domains) > 9 ? 1 : 0

  domain          = local.domains[9]
  rtype           = local.rrsets[local.domains[9]].rtype
  zone_name_or_id = local.zone_name_or_id

depends_on = [oci_dns_rrset.no_8]

  dynamic "items" {
    for_each = local.rrsets[local.domains[9]].records
    content {
      domain = local.domains[9]
      rdata  = items.value.rdata
      rtype  = coalesce(items.value.rtype, local.rrsets[local.domains[9]].rtype)
      ttl    = coalesce(items.value.ttl, local.rrsets[local.domains[9]].ttl)
    }
  }
}

resource "oci_dns_rrset" "no_10" {
  count           = length(local.domains) > 10 ? 1 : 0

  domain          = local.domains[10]
  rtype           = local.rrsets[local.domains[10]].rtype
  zone_name_or_id = local.zone_name_or_id

depends_on = [oci_dns_rrset.no_9]

  dynamic "items" {
    for_each = local.rrsets[local.domains[10]].records
    content {
      domain = local.domains[10]
      rdata  = items.value.rdata
      rtype  = coalesce(items.value.rtype, local.rrsets[local.domains[10]].rtype)
      ttl    = coalesce(items.value.ttl, local.rrsets[local.domains[10]].ttl)
    }
  }
}

resource "oci_dns_rrset" "no_11" {
  count           = length(local.domains) > 11 ? 1 : 0

  domain          = local.domains[11]
  rtype           = local.rrsets[local.domains[11]].rtype
  zone_name_or_id = local.zone_name_or_id

depends_on = [oci_dns_rrset.no_10]

  dynamic "items" {
    for_each = local.rrsets[local.domains[11]].records
    content {
      domain = local.domains[11]
      rdata  = items.value.rdata
      rtype  = coalesce(items.value.rtype, local.rrsets[local.domains[11]].rtype)
      ttl    = coalesce(items.value.ttl, local.rrsets[local.domains[11]].ttl)
    }
  }
}

resource "oci_dns_rrset" "no_12" {
  count           = length(local.domains) > 12 ? 1 : 0

  domain          = local.domains[12]
  rtype           = local.rrsets[local.domains[12]].rtype
  zone_name_or_id = local.zone_name_or_id

depends_on = [oci_dns_rrset.no_11]

  dynamic "items" {
    for_each = local.rrsets[local.domains[12]].records
    content {
      domain = local.domains[12]
      rdata  = items.value.rdata
      rtype  = coalesce(items.value.rtype, local.rrsets[local.domains[12]].rtype)
      ttl    = coalesce(items.value.ttl, local.rrsets[local.domains[12]].ttl)
    }
  }
}

resource "oci_dns_rrset" "no_13" {
  count           = length(local.domains) > 13 ? 1 : 0

  domain          = local.domains[13]
  rtype           = local.rrsets[local.domains[13]].rtype
  zone_name_or_id = local.zone_name_or_id

depends_on = [oci_dns_rrset.no_12]

  dynamic "items" {
    for_each = local.rrsets[local.domains[13]].records
    content {
      domain = local.domains[13]
      rdata  = items.value.rdata
      rtype  = coalesce(items.value.rtype, local.rrsets[local.domains[13]].rtype)
      ttl    = coalesce(items.value.ttl, local.rrsets[local.domains[13]].ttl)
    }
  }
}

resource "oci_dns_rrset" "no_14" {
  count           = length(local.domains) > 14 ? 1 : 0

  domain          = local.domains[14]
  rtype           = local.rrsets[local.domains[14]].rtype
  zone_name_or_id = local.zone_name_or_id

depends_on = [oci_dns_rrset.no_13]

  dynamic "items" {
    for_each = local.rrsets[local.domains[14]].records
    content {
      domain = local.domains[14]
      rdata  = items.value.rdata
      rtype  = coalesce(items.value.rtype, local.rrsets[local.domains[14]].rtype)
      ttl    = coalesce(items.value.ttl, local.rrsets[local.domains[14]].ttl)
    }
  }
}

resource "oci_dns_rrset" "no_15" {
  count           = length(local.domains) > 15 ? 1 : 0

  domain          = local.domains[15]
  rtype           = local.rrsets[local.domains[15]].rtype
  zone_name_or_id = local.zone_name_or_id

depends_on = [oci_dns_rrset.no_14]

  dynamic "items" {
    for_each = local.rrsets[local.domains[15]].records
    content {
      domain = local.domains[15]
      rdata  = items.value.rdata
      rtype  = coalesce(items.value.rtype, local.rrsets[local.domains[15]].rtype)
      ttl    = coalesce(items.value.ttl, local.rrsets[local.domains[15]].ttl)
    }
  }
}

resource "oci_dns_rrset" "no_16" {
  count           = length(local.domains) > 16 ? 1 : 0

  domain          = local.domains[16]
  rtype           = local.rrsets[local.domains[16]].rtype
  zone_name_or_id = local.zone_name_or_id

depends_on = [oci_dns_rrset.no_15]

  dynamic "items" {
    for_each = local.rrsets[local.domains[16]].records
    content {
      domain = local.domains[16]
      rdata  = items.value.rdata
      rtype  = coalesce(items.value.rtype, local.rrsets[local.domains[16]].rtype)
      ttl    = coalesce(items.value.ttl, local.rrsets[local.domains[16]].ttl)
    }
  }
}

resource "oci_dns_rrset" "no_17" {
  count           = length(local.domains) > 17 ? 1 : 0

  domain          = local.domains[17]
  rtype           = local.rrsets[local.domains[17]].rtype
  zone_name_or_id = local.zone_name_or_id

depends_on = [oci_dns_rrset.no_16]

  dynamic "items" {
    for_each = local.rrsets[local.domains[17]].records
    content {
      domain = local.domains[17]
      rdata  = items.value.rdata
      rtype  = coalesce(items.value.rtype, local.rrsets[local.domains[17]].rtype)
      ttl    = coalesce(items.value.ttl, local.rrsets[local.domains[17]].ttl)
    }
  }
}

resource "oci_dns_rrset" "no_18" {
  count           = length(local.domains) > 18 ? 1 : 0

  domain          = local.domains[18]
  rtype           = local.rrsets[local.domains[18]].rtype
  zone_name_or_id = local.zone_name_or_id

depends_on = [oci_dns_rrset.no_17]

  dynamic "items" {
    for_each = local.rrsets[local.domains[18]].records
    content {
      domain = local.domains[18]
      rdata  = items.value.rdata
      rtype  = coalesce(items.value.rtype, local.rrsets[local.domains[18]].rtype)
      ttl    = coalesce(items.value.ttl, local.rrsets[local.domains[18]].ttl)
    }
  }
}

resource "oci_dns_rrset" "no_19" {
  count           = length(local.domains) > 19 ? 1 : 0

  domain          = local.domains[19]
  rtype           = local.rrsets[local.domains[19]].rtype
  zone_name_or_id = local.zone_name_or_id

depends_on = [oci_dns_rrset.no_18]

  dynamic "items" {
    for_each = local.rrsets[local.domains[19]].records
    content {
      domain = local.domains[19]
      rdata  = items.value.rdata
      rtype  = coalesce(items.value.rtype, local.rrsets[local.domains[19]].rtype)
      ttl    = coalesce(items.value.ttl, local.rrsets[local.domains[19]].ttl)
    }
  }
}
