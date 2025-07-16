# OCI DNS rrset concurrent operation failures
https://github.com/rstyczynski/terraform-oci-resource-dns-records/blob/main/unit_test/RETRY.md

## Zone update conflict, retry, and the circuit breaker

OCI SDK supports a sophisticated retry mechanism based on quadratic backoff and full jitter, which backs off failed requests for an increasing amount of time and randomizes the final time shift. This technique makes probability of update conflict very low leading to fast recovery. The retry technique built into the OCI SDK [1] is implemented in Terraform OCI Provider, stating that [2]: "To alleviate contention between parallel operations against OCI services; the OCI Terraform provider schedules retry attempts using quadratic backoff and full jitter. Quadratic backoff increases the maximum interval between subsequent retry attempts, while full jitter randomly selects a retry interval within the backoff range."

According to the documentation, the 409 error is explicitly eliminated from the retry mechanism as a non-recoverable one, which is an obvious error. 

"Note that the retry_duration_seconds field only affects retry duration in response to HTTP 429 and 500 errors; as these errors are more likely to result in success after a long retry duration. Other HTTP errors (such as 400, 401, 403, 404, and 409) are unlikely to succeed on retry. The retry_duration_seconds field does not affect the retry behavior for such errors."

Oracle promises that the 429 error is recoverable through the retry mechanism, which is not confirmed by the DNS rrset resource Terraform provider behaviour.

## ANALYSIS

Analysis of the request flow uncovers the root causes, as terraform processing fails on three-errors: 409, 429 and the "circuit breaker":
- 409 comes from DNS service,
- 429 comes from throttling service protecting downstream services from overload,
- circuit breaker is SDK side protection.

## HYPOTHESIS

All these layers create a stream of problems blocking the parallel operation of rrset resources. DNS service reports by-design error in case of concurrent update of the zone. That's correct and expected with current rrset resource design. The retry mechanism, however, seems to ignore the SDK-style randomized backoff approach, as the processing log emits information describing a misconfigured retry policy {MaximumNumberAttempts=10, MinSleepBetween=0, MaxSleepBetween=0, ExponentialBackoffBase=0, NonEventuallyConsistentPolicy=<nil>}, which is most probably the root cause of the storm of requests since ExponentialBackoffBase, MinSleepBetween, and MaxSleepBetween are all zeros. That means that 10 retries are pushed w/o backoff and jitter strategy, which is guaranteed by Oracle SDK. Finally retry produces reaction of the throttling layer that emits 429 too-many-requests error which is retried by the SDK to be finally blocked by the circuit breaker of the same SDK. 

Knowing that both 409, and 429 are repeated by a retry mechanism I applied env flag to control circuit breaker [4].

The presented request failure, retry, throttling, and circuit breaker is the most probable root cause and chain of effects; however, it should be additionally verified, as of course, I may be mistaken. 

## VERIFICATION

To minimise the probability of an error, I conducted a series of tests that verify the hypothesis.

The conducted tests execute same identical rrset creation flow in four conditions:
1. vanilla 
2. vanilla with disabled circuit breaker
3. retry_duration_seconds set to 1800 seconds
4. retry_duration_seconds set to 1800 seconds with disabled circuit breaker
5. retry disabled by Terraform OCI Provider arguments

, in modes with and without SDK debug flags.

## TESTS

To run the test set proper value of domain and zone id at the end of tests_retry.sh 

```bash
cd unit_test
./tests_retry.sh
```

Expected current state of tests is the following:

```
TEST REPORT
--------------------------------
Terraform module: terraform-oci-resource-dns-records
Test suite:       unit_test
Test date:        2025-07-16_15-47-30

name                           | status                                  
-------------------------------+-----------------------------------------
test_test_1_vanilla_debug      | 1 FAILED ❌                            
test_test_1_vanilla            | 1 FAILED ❌                            
test_test_2_vanilla_no_cb_debug | 0 PASSED ✅                            
test_test_2_vanilla_no_cb      | 0 PASSED ✅                            
test_test_3_retry_debug        | 1 FAILED ❌                            
test_test_3_retry              | 1 FAILED ❌                            
test_test_4_retry_no_cb_debug  | 0 PASSED ✅                            
test_test_4_retry_no_cb        | 0 PASSED ✅                            
test_test_5_no_retry_debug     | 1 PASSED ✅ (expected failure in negative test)
test_test_5_no_retry           | 1 PASSED ✅ (expected failure in negative test)

--------------------------------
SOME TESTS FAILED (4 of 10) ❌
```

Note that logs are collected in unit_test/logs directory, where you will find log files collected for each test.

Target state is all green.

## CONCLUSIONS

The performed analysis and tests clearly present that the root cause is in the circuit breaker logic that weakly cooperates with OCI throttling protection.

## QUICK FIX

A quick fix is to apply the SDK layer control environment variable to disable the circuit breaker.

OCI_SDK_DEFAULT_CIRCUITBREAKER_ENABLED=false 

## ACTION PLAN:

1. fix misleading information in documentation that 409 is not retried [2].

2. fix retry policy {MaximumNumberAttempts=10, MinSleepBetween=0, MaxSleepBetween=0, ExponentialBackoffBase=0, NonEventuallyConsistentPolicy=<nil>} to proper values enabling backoff and jitter.

3. Expose retry policy (MaximumNumberAttempts, MinSleepBetween, MaxSleepBetween, ExponentialBackoffBase) parameters to terraform oci provider properties

4. Expose circuit breaker control (disable, request count) to terraform oci provider properties


## TERRAFORM ZONE RESOURCE EXTENSION

All the problems arise because of the externalisation of the rrset resource from the zone. rrset management may be simplified extending current zone resource with clear mapping to the API. The proposed change makes it possible to utilise a simple PATCH call to the zone object, which eliminates all issues related to parallelism. It's the target state—not required now, but most welcome in the future. This model mimics the OCI CLI, which I guess is closer to the DNS API. The externalisation of rrset looks very synthetic and may probably be applied to some special cases to utilise IAM access control, but typical use cases are fully covered by the Zone API.

```hcl
resource "oci_dns_zone" "zone_idea" {
    compartment_id = var.compartment_id
    name = var.zone_name
    zone_type = var.zone_zone_type

  rrset {
    record {
      domain = var.rrset_items_domain_1
      rdata  = var.rrset_items_rdata_1
      rtype  = var.rrset_items_rtype_1
      ttl    = var.rrset_items_ttl_1
    }

    record {
      domain = var.rrset_items_domain_2
      rdata  = var.rrset_items_rdata_2
      rtype  = var.rrset_items_rtype_2
      ttl    = var.rrset_items_ttl_2
    }
  }

  (...)
}
```

References
1. https://docs.oracle.com/en-us/iaas/tools/python/2.155.1/sdk_behaviors/retries.html
2. https://docs.oracle.com/en-us/iaas/Content/dev/terraform/troubleshooting.htm#backoffandjitter
3. Circuit breaker, https://docs.oracle.com/en-us/iaas/tools/go/65.95.2/
4. https://docs.oracle.com/en-us/iaas/tools/python/2.155.2/sdk_behaviors/circuit_breakers.html

