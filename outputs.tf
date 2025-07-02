output "domains" {
  description = "RRSet Keys."
  value = local.domains
}

output "dns_record_details" {
  description = "Created DNS Record Details."
  value = {
    for idx, key in local.domains :
      key => try(
        lookup(
          {
            0  = oci_dns_rrset.no_0
            1  = oci_dns_rrset.no_1
            2  = oci_dns_rrset.no_2
            3  = oci_dns_rrset.no_3
            4  = oci_dns_rrset.no_4
            5  = oci_dns_rrset.no_5
            6  = oci_dns_rrset.no_6
            7  = oci_dns_rrset.no_7
            8  = oci_dns_rrset.no_8
            9  = oci_dns_rrset.no_9
            10 = oci_dns_rrset.no_10
            11 = oci_dns_rrset.no_11
            12 = oci_dns_rrset.no_12
            13 = oci_dns_rrset.no_13
            14 = oci_dns_rrset.no_14
            15 = oci_dns_rrset.no_15
            16 = oci_dns_rrset.no_16
            17 = oci_dns_rrset.no_17
            18 = oci_dns_rrset.no_18
            19 = oci_dns_rrset.no_19
          },
          idx,
          []
        )[0].items,
        []
      )
  }
   
}