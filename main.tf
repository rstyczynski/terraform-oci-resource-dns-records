

locals {
  zone_name_or_id = var.zone_name_or_id
  rrsets         = var.rrsets
}

resource "oci_dns_rrset" "no_0" {
  count           = length(local.rrsets) > 0 ? 1 : 0
  domain          = local.rrsets[0].domain
  rtype           = local.rrsets[0].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[0].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_1" {
  count           = length(local.rrsets) > 1 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_0]
  domain          = local.rrsets[1].domain
  rtype           = local.rrsets[1].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[1].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_2" {
  count           = length(local.rrsets) > 2 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_1]
  domain          = local.rrsets[2].domain
  rtype           = local.rrsets[2].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[2].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_3" {
  count           = length(local.rrsets) > 3 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_2]
  domain          = local.rrsets[3].domain
  rtype           = local.rrsets[3].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[3].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_4" {
  count           = length(local.rrsets) > 4 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_3]
  domain          = local.rrsets[4].domain
  rtype           = local.rrsets[4].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[4].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_5" {
  count           = length(local.rrsets) > 5 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_4]
  domain          = local.rrsets[5].domain
  rtype           = local.rrsets[5].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[5].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_6" {
  count           = length(local.rrsets) > 6 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_5]
  domain          = local.rrsets[6].domain
  rtype           = local.rrsets[6].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[6].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_7" {
  count           = length(local.rrsets) > 7 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_6]
  domain          = local.rrsets[7].domain
  rtype           = local.rrsets[7].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[7].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_8" {
  count           = length(local.rrsets) > 8 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_7]
  domain          = local.rrsets[8].domain
  rtype           = local.rrsets[8].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[8].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_9" {
  count           = length(local.rrsets) > 9 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_8]
  domain          = local.rrsets[9].domain
  rtype           = local.rrsets[9].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[9].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_10" {
  count           = length(local.rrsets) > 10 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_9]
  domain          = local.rrsets[10].domain
  rtype           = local.rrsets[10].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[10].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_11" {
  count           = length(local.rrsets) > 11 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_10]
  domain          = local.rrsets[11].domain
  rtype           = local.rrsets[11].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[11].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_12" {
  count           = length(local.rrsets) > 12 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_11]
  domain          = local.rrsets[12].domain
  rtype           = local.rrsets[12].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[12].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_13" {
  count           = length(local.rrsets) > 13 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_12]
  domain          = local.rrsets[13].domain
  rtype           = local.rrsets[13].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[13].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_14" {
  count           = length(local.rrsets) > 14 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_13]
  domain          = local.rrsets[14].domain
  rtype           = local.rrsets[14].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[14].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_15" {
  count           = length(local.rrsets) > 15 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_14]
  domain          = local.rrsets[15].domain
  rtype           = local.rrsets[15].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[15].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_16" {
  count           = length(local.rrsets) > 16 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_15]
  domain          = local.rrsets[16].domain
  rtype           = local.rrsets[16].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[16].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_17" {
  count           = length(local.rrsets) > 17 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_16]
  domain          = local.rrsets[17].domain
  rtype           = local.rrsets[17].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[17].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_18" {
  count           = length(local.rrsets) > 18 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_17]
  domain          = local.rrsets[18].domain
  rtype           = local.rrsets[18].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[18].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_19" {
  count           = length(local.rrsets) > 19 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_18]
  domain          = local.rrsets[19].domain
  rtype           = local.rrsets[19].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[19].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_20" {
  count           = length(local.rrsets) > 20 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_19]
  domain          = local.rrsets[20].domain
  rtype           = local.rrsets[20].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[20].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_21" {
  count           = length(local.rrsets) > 21 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_20]
  domain          = local.rrsets[21].domain
  rtype           = local.rrsets[21].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[21].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_22" {
  count           = length(local.rrsets) > 22 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_21]
  domain          = local.rrsets[22].domain
  rtype           = local.rrsets[22].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[22].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_23" {
  count           = length(local.rrsets) > 23 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_22]
  domain          = local.rrsets[23].domain
  rtype           = local.rrsets[23].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[23].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_24" {
  count           = length(local.rrsets) > 24 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_23]
  domain          = local.rrsets[24].domain
  rtype           = local.rrsets[24].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[24].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_25" {
  count           = length(local.rrsets) > 25 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_24]
  domain          = local.rrsets[25].domain
  rtype           = local.rrsets[25].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[25].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_26" {
  count           = length(local.rrsets) > 26 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_25]
  domain          = local.rrsets[26].domain
  rtype           = local.rrsets[26].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[26].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_27" {
  count           = length(local.rrsets) > 27 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_26]
  domain          = local.rrsets[27].domain
  rtype           = local.rrsets[27].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[27].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_28" {
  count           = length(local.rrsets) > 28 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_27]
  domain          = local.rrsets[28].domain
  rtype           = local.rrsets[28].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[28].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_29" {
  count           = length(local.rrsets) > 29 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_28]
  domain          = local.rrsets[29].domain
  rtype           = local.rrsets[29].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[29].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_30" {
  count           = length(local.rrsets) > 30 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_29]
  domain          = local.rrsets[30].domain
  rtype           = local.rrsets[30].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[30].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_31" {
  count           = length(local.rrsets) > 31 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_30]
  domain          = local.rrsets[31].domain
  rtype           = local.rrsets[31].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[31].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_32" {
  count           = length(local.rrsets) > 32 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_31]
  domain          = local.rrsets[32].domain
  rtype           = local.rrsets[32].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[32].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_33" {
  count           = length(local.rrsets) > 33 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_32]
  domain          = local.rrsets[33].domain
  rtype           = local.rrsets[33].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[33].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_34" {
  count           = length(local.rrsets) > 34 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_33]
  domain          = local.rrsets[34].domain
  rtype           = local.rrsets[34].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[34].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_35" {
  count           = length(local.rrsets) > 35 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_34]
  domain          = local.rrsets[35].domain
  rtype           = local.rrsets[35].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[35].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_36" {
  count           = length(local.rrsets) > 36 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_35]
  domain          = local.rrsets[36].domain
  rtype           = local.rrsets[36].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[36].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_37" {
  count           = length(local.rrsets) > 37 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_36]
  domain          = local.rrsets[37].domain
  rtype           = local.rrsets[37].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[37].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_38" {
  count           = length(local.rrsets) > 38 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_37]
  domain          = local.rrsets[38].domain
  rtype           = local.rrsets[38].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[38].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_39" {
  count           = length(local.rrsets) > 39 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_38]
  domain          = local.rrsets[39].domain
  rtype           = local.rrsets[39].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[39].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_40" {
  count           = length(local.rrsets) > 40 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_39]
  domain          = local.rrsets[40].domain
  rtype           = local.rrsets[40].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[40].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_41" {
  count           = length(local.rrsets) > 41 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_40]
  domain          = local.rrsets[41].domain
  rtype           = local.rrsets[41].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[41].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_42" {
  count           = length(local.rrsets) > 42 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_41]
  domain          = local.rrsets[42].domain
  rtype           = local.rrsets[42].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[42].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_43" {
  count           = length(local.rrsets) > 43 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_42]
  domain          = local.rrsets[43].domain
  rtype           = local.rrsets[43].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[43].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_44" {
  count           = length(local.rrsets) > 44 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_43]
  domain          = local.rrsets[44].domain
  rtype           = local.rrsets[44].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[44].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_45" {
  count           = length(local.rrsets) > 45 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_44]
  domain          = local.rrsets[45].domain
  rtype           = local.rrsets[45].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[45].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_46" {
  count           = length(local.rrsets) > 46 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_45]
  domain          = local.rrsets[46].domain
  rtype           = local.rrsets[46].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[46].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_47" {
  count           = length(local.rrsets) > 47 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_46]
  domain          = local.rrsets[47].domain
  rtype           = local.rrsets[47].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[47].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_48" {
  count           = length(local.rrsets) > 48 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_47]
  domain          = local.rrsets[48].domain
  rtype           = local.rrsets[48].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[48].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

resource "oci_dns_rrset" "no_49" {
  count           = length(local.rrsets) > 49 ? 1 : 0
  depends_on      = [oci_dns_rrset.no_48]
  domain          = local.rrsets[49].domain
  rtype           = local.rrsets[49].rtype
  zone_name_or_id = local.zone_name_or_id

  dynamic "items" {
    for_each = local.rrsets[49].records
    content {
      domain = items.value.domain
      rdata  = items.value.rdata
      rtype  = items.value.rtype
      ttl    = items.value.ttl
    }
  }
}

