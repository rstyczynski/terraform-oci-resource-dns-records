# Provider 7.27 adds retry mechanism reconfiguration

## Test summary

Provided solution works with proper configuration and small number of threads.

## Test procedure

1. configure SDK access to target tenancy
2. configure DNS Zone at OCI with name `acme.org`

3. clone test repo

```
git clone https://github.com/rstyczynski/terraform-oci-resource-dns-records
```

4. prepare retry files

```
terraform-oci-resource-dns-records
cat > providers_oci_retry.json <<EOF
{
	"409": {
		"retry_max_duration": 300,
        "first_retry_sleep_duration": 30
	}, 
	"429": {
		"retry_max_duration": 300,
        "first_retry_sleep_duration": 30
	}
}
EOF

cat > providers_oci_retry.tf <<EOF
provider "oci" {
  retries_config_file = "$PWD/providers_oci_retry.json"
}
EOF
```

5. perform test

```bash
cd unit_test

export TF_VAR_rrsets=$(sed 's/acme.org/acme.org/' data/dataset1.acme)
export TF_VAR_zone_name_or_id="ocid1.dns-zone.oc1..aaaaaaaarh7borfqosuhymrv6pjh2m7nqhj27ctaqgtyctee2zpyc67xo6ta"

. tests/unit_tests.sh 
for test_no in {1..10}; do
  test_prepare test_727_3threads_30sec_apply_${test_no} regular destroy
  test_apply 3
  test_prepare test_727_3threads_30sec_destroy_${test_no} regular destroy
  test_destroy 3
done
```
