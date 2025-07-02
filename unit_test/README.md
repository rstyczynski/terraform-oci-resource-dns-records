# Serialized RRSet tests

This test set demonstrates how to validate the serialization of OCI DNS RRSet resources using Terraform. It includes negative and positive tests to show the impact of parallelism and the importance of using `depends_on` to avoid race conditions (such as HTTP 409 conflicts) when managing multiple DNS records in the same zone. Note that depend_on is controlled with direct editing of main.tf using sed.

> **Note:**
>
> - You **must** update the `zone_name_or_id` variable in `main.tf` to match your own DNS zone OCID before running these tests.
> - copy/paste each section to terminal session to execute tests

## Helper function

```bash
function check_errors() {
    local operation="$1"
    local parallelism="$2"
    local status="$3"
    local logfile="$4"

    if [ "$status" -eq 0 ]; then
    echo "✅ Terraform $operation succeeded with parallelism=$parallelism."
    else
        echo "❌ Terraform $operation failed with status code $status."
        if grep -q "409" "$logfile" 2>/dev/null; then
            echo "⚠️ 409 Conflict detected! This is likely due to race conditions from parallel execution without serialization."
        else
            echo "Check above for error details."
        fi
    fi
}
```

## ❌ Negative test: Crash on 409 during apply due to parallelism enabled but no serialization

Parallel execution without depends_on causes race condition and conflict.

```bash
sed -i '' 's/^\([[:space:]]*\)depends_on/#depends_on/' ../main.tf

thrds=20
exit_code=0

test_prepare() {
    terraform destroy -parallelism=1 -auto-approve 2>&1 | tee test_prepare.log
    exit_code=${PIPESTATUS[0]}
    check_errors destroy 1 $exit_code test_prepare.log
}
test_prepare

test_apply() {
    terraform apply -parallelism=$thrds -auto-approve 2>&1 | tee test_apply.log
    exit_code=${PIPESTATUS[0]}
    check_errors apply $thrds $exit_code test_apply.log
}
test_apply
```

## ❌ Negative test: Crash on 409 during destroy due to parallelism enabled but no serialization

Parallel execution without depends_on causes race condition and conflict.

```bash
sed -i '' 's/^\([[:space:]]*\)depends_on/#depends_on/' ../main.tf

thrds=20
exit_code=0

test_prepare() {
    terraform apply -parallelism=1 -auto-approve 2>&1 | tee test_prepare.log
    exit_code=${PIPESTATUS[0]}
    check_errors apply 1 $exit_code test_prepare.log
}
test_prepare

test_destroy() {
    terraform destroy -parallelism=$thrds -auto-approve 2>&1 | tee test_destroy.log
    exit_code=${PIPESTATUS[0]}
    check_errors destroy $thrds $exit_code test_destroy.log
}
test_destroy
```

## ✅ Positive test: Run in 20 threads with `depends_on` enabled

Parallel execution with depends_on serializes zone update, what eliminates conflicts.

```bash
sed -i '' 's/^\([[:space:]]*\)#depends_on/depends_on/' ../main.tf

thrds=20
exit_code=0

test_prepare() {
    terraform destroy -parallelism=1 -auto-approve 2>&1 | tee test_prepare.log
    exit_code=${PIPESTATUS[0]}
    check_errors destroy 1 $exit_code test_prepare.log
}
test_prepare

test_apply() {
    terraform apply -parallelism=$thrds -auto-approve 2>&1 | tee test_apply.log
    exit_code=${PIPESTATUS[0]}
    check_errors apply $thrds $exit_code test_apply.log
}
test_apply

test_destroy() {
    terraform destroy -parallelism=$thrds -auto-approve 2>&1 | tee test_destroy.log
    exit_code=${PIPESTATUS[0]}
    check_errors destroy $thrds $exit_code test_destroy.log
}
test_destroy
```

## ✅ Positive test: Run with 1 thread (serialization not needed)

Single threaded execution without depends_on does not create conflicts, but influences whole TF processing, no only rrsets.

```bash
sed -i '' 's/^\([[:space:]]*\)depends_on/#depends_on/' ../main.tf

thrds=1
exit_code=0

test_prepare() {
    terraform destroy -parallelism=1 -auto-approve 2>&1 | tee test_prepare.log
    exit_code=${PIPESTATUS[0]}
    check_errors destroy 1 $exit_code test_prepare.log
}
test_prepare

test_apply() {
    terraform apply -parallelism=$thrds -auto-approve 2>&1 | tee test_apply.log
    exit_code=${PIPESTATUS[0]}
    check_errors apply $thrds $exit_code test_apply.log
}
test_apply

test_destroy() {
    terraform destroy -parallelism=$thrds -auto-approve 2>&1 | tee test_destroy.log
    exit_code=${PIPESTATUS[0]}
    check_errors destroy $thrds $exit_code test_destroy.log
}
test_destroy

```
