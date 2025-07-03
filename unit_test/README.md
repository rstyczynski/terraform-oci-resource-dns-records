# Serialized RRSet tests

This test set demonstrates how to validate the serialization of OCI DNS RRSet resources using Terraform. It includes negative and positive tests to show the impact of parallelism and the importance of using `depends_on` to avoid race conditions (such as HTTP 409 conflicts) when managing multiple DNS records in the same zone. Note that depend_on is controlled with direct editing of main.tf using sed inline editor.

> **Note**
> copy/paste each section to terminal session to execute tests

## Prepare test data

Test data coded in dataset1.acme handles acme.org domain. Adjust it to your needs i.e. domain managed by the zone, and set value of the zone OCID.

```bash
export TF_VAR_rrsets=$(sed 's/acme.org/acme.org/' data/dataset1.acme)
export TF_VAR_zone_name_or_id="ocid1.dns-zone.oc1..aaaaaaaarh7borfqosuhymrv6pjh2m7nqhj27ctaqgtyctee2zpyc67xo6ta"

```

## ❌ Negative test. Test 1: Crash on 409 during apply due to parallelism enabled but no serialization

Parallel execution without depends_on causes race condition and conflict.

```bash
. tests/unit_tests.sh
test_prepare test_1 regular destroy

test_apply 20 negative

test_cleanup

```

## ❌ Negative test. Test 2: Crash on 409 during destroy due to parallelism enabled but no serialization

Parallel execution without depends_on causes race condition and conflict.

```bash
. tests/unit_tests.sh
test_prepare test_2 regular apply 

test_destroy 20 negative

test_cleanup

```

## ✅ Positive test. Test 3: Run in 20 threads with `depends_on` enabled

Parallel execution with depends_on serializes zone update, what eliminates conflicts. Both apply and destroy will run.

```bash
. tests/unit_tests.sh
test_prepare test_3a serialized destroy
test_apply 20
test_cleanup

test_prepare test_3b serialized apply
test_destroy 20
test_cleanup

```

## ✅ Positive test. Test 4: Run with 1 thread (serialization not needed)

Single threaded execution without depends_on does not create conflicts, but influences whole TF processing, no only rrsets. **This test is added just for informative purposes, as it's not realistic use case in the real production deployment**.

```bash
. tests/unit_tests.sh
test_prepare test_4a regular destroy 
test_apply 1
test_cleanup

test_prepare test_4b regular apply
test_destroy 1
test_cleanup

```

## Look for test status

```bash
. tests/unit_tests.sh
test_report all

```

## Further tests

- different ttl in records
- mixed rtypes in records
- protected rrsets

## Test approach extension

- all good

## Features

(...)

* Module code is copied to a temporary location, to prevent directly edit of the source code in repository
* summary test report in place
