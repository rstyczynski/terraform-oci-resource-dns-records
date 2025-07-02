# Serialized RRSet tests

This test set demonstrates how to validate the serialization of OCI DNS RRSet resources using Terraform. It includes negative and positive tests to show the impact of parallelism and the importance of using `depends_on` to avoid race conditions (such as HTTP 409 conflicts) when managing multiple DNS records in the same zone. Note that depend_on is controlled with direct editing of main.tf using sed.

> **Note:**
>
> - You **must** update the `zone_name_or_id` variable in `main.tf` to match your own DNS zone OCID before running these tests.
> - copy/paste each section to terminal session to execute tests


## ❌ Negative test: Crash on 409 during apply due to parallelism enabled but no serialization

Parallel execution without depends_on causes race condition and conflict.

```bash
. bin/helper.sh
test_prepare regular

test_apply 20

test_cleanup
```

## ❌ Negative test: Crash on 409 during destroy due to parallelism enabled but no serialization

Parallel execution without depends_on causes race condition and conflict.

```bash
. bin/helper.sh
test_prepare regular apply

test_destroy 20

test_cleanup
```

## ✅ Positive test: Run in 20 threads with `depends_on` enabled

Parallel execution with depends_on serializes zone update, what eliminates conflicts. Both apply and destroy will run.

```bash
. bin/helper.sh
test_prepare serialized

test_apply 20
test_destroy 20

test_cleanup
```

## ✅ Positive test: Run with 1 thread (serialization not needed)

Single threaded execution without depends_on does not create conflicts, but influences whole TF processing, no only rrsets. This test is added just for informative purposes, as it's not realistic use case in the real production deployment.

```bash
. bin/helper.sh
test_prepare regular

test_apply 1
test_destroy 1

test_cleanup
```
