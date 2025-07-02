module "dns_records" {
  source = "../"

  zone_name_or_id = "ocid1.dns-zone.oc1..aaaaaaaarh7borfqosuhymrv6pjh2m7nqhj27ctaqgtyctee2zpyc67xo6ta"
  rrsets = [
    {
      domain  = "db.acme.org"
      rtype   = "A"
      records = [
        {
          domain = "db.acme.org"
          rdata  = "10.0.0.10"
          rtype  = "A"
          ttl    = 5
        },
        {
          domain = "db.acme.org"
          rdata  = "10.0.0.11"
          rtype  = "A"
          ttl    = 5
        }
      ]
    },
    {
      domain  = "web.acme.org"
      rtype   = "A"
      records = [
        {
          domain = "web.acme.org"
          rdata  = "10.0.0.20"
        }
      ]
    },
    {
      domain  = "mail.acme.org"
      rtype   = "MX"
      records = [
        {
          domain = "mail.acme.org"
          rdata  = "10 mail1.acme.org."
          rtype  = "MX"
          ttl    = 300
        }
      ]
    },
    {
      domain  = "api.acme.org"
      rtype   = "A"
      records = [
        {
          domain = "api.acme.org"
          rdata  = "10.0.0.30"
        }
      ]
    },
    {
      domain  = "vpn.acme.org"
      rtype   = "A"
      records = [
        {
          domain = "vpn.acme.org"
          rdata  = "10.0.0.40"
        }
      ]
    },
    {
      domain  = "ftp.acme.org"
      rtype   = "A"
      records = [
        {
          domain = "ftp.acme.org"
          rdata  = "10.0.0.50"
        }
      ]
    },
    {
      domain  = "dev1.internal.acme.org"
      rtype   = "A"
      records = [
        {
          domain = "dev1.internal.acme.org"
          rdata  = "10.1.0.10"
        }
      ]
    },
    {
      domain  = "dev2.internal.acme.org"
      rtype   = "A"
      records = [
        {
          domain = "dev2.internal.acme.org"
          rdata  = "10.1.0.11"
        }
      ]
    },
    {
      domain  = "test1.lab.acme.org"
      rtype   = "A"
      records = [
        {
          domain = "test1.lab.acme.org"
          rdata  = "10.2.0.10"
        }
      ]
    },
    {
      domain  = "test2.lab.acme.org"
      rtype   = "A"
      records = [
        {
          domain = "test2.lab.acme.org"
          rdata  = "10.2.0.11"
        }
      ]
    },
    {
      domain  = "cdn.acme.org"
      rtype   = "CNAME"
      records = [
        {
          domain = "cdn.acme.org"
          rdata  = "cdn.provider.com."
          rtype  = "CNAME"
        }
      ]
    },
    {
      domain  = "blog.acme.org"
      rtype   = "A"
      records = [
        {
          domain = "blog.acme.org"
          rdata  = "10.0.0.60"
        }
      ]
    },
    {
      domain  = "shop.acme.org"
      rtype   = "A"
      records = [
        {
          domain = "shop.acme.org"
          rdata  = "10.0.0.70"
        }
      ]
    },
    {
      domain  = "support.acme.org"
      rtype   = "A"
      records = [
        {
          domain = "support.acme.org"
          rdata  = "10.0.0.80"
        }
      ]
    },
    {
      domain  = "status.acme.org"
      rtype   = "A"
      records = [
        {
          domain = "status.acme.org"
          rdata  = "10.0.0.90"
        }
      ]
    },
    {
      domain  = "monitor.acme.org"
      rtype   = "A"
      records = [
        {
          domain = "monitor.acme.org"
          rdata  = "10.0.0.100"
        }
      ]
    },
    {
      domain  = "auth.acme.org"
      rtype   = "A"
      records = [
        {
          domain = "auth.acme.org"
          rdata  = "10.0.0.110"
        }
      ]
    },
    {
      domain  = "cache.acme.org"
      rtype   = "A"
      records = [
        {
          domain = "cache.acme.org"
          rdata  = "10.0.0.120"
        }
      ]
    },
    {
      domain  = "docs.acme.org"
      rtype   = "A"
      records = [
        {
          domain = "docs.acme.org"
          rdata  = "10.0.0.130"
        }
      ]
    },
    {
      domain  = "portal.acme.org"
      rtype   = "A"
      records = [
        {
          domain = "portal.acme.org"
          rdata  = "10.0.0.140"
        }
      ]
    }
  ]
}
