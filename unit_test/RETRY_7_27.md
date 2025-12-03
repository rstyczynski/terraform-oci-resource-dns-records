# Provider 7.27 adds retry mechanism reconfiguration

## Test summary

Provided solution does not work, increasing probability of success, but in fact postponing the failure.

It was observed that configured delay is strictly used, what means that in case of 409 conflicts that are about to be retried, all the retry group will happen after first round of configured delay, what will create the same storm on API with the same circuit breaker reaction. This was observed for 10, 30, and 60 seconds delays. It not worked even with so long delay as 120 seconds, which was tested, being not practical at all.

The retry mechanism ignores 429 errors, what was interesting option to go out of circuit breaker 30 seconds window.

Performed tests and analysis makes the update status as FAILED.

## Recommendation

Solution should distribute retries on the retry window to eliminate storm of API calls. According to the product documentation, Terraform OCI Provider implements backoff with jitter, what is exactly should be applied to solve the problem. Solution should react on 429 to enable move out of circuit breaker window. Solution should be tested before releasing.

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
		"retry_max_duration": 600,
        "first_retry_sleep_duration": 60
	}, 
	"429": {
		"retry_max_duration": 600,
        "first_retry_sleep_duration": 60
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
