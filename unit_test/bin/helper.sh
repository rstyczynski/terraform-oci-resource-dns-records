#!/bin/bash

#
# test preparation and cleaning
#

test_prepare() {
    local test_type=${1:-regular}
    local test_action=${2:-destroy}

    case $test_type in
    regular)
        sed -i '' 's/^\([[:space:]]*\)depends_on/#depends_on/' ../main.tf
        ;;
    serialized)
        sed -i '' 's/^\([[:space:]]*\)#depends_on/depends_on/' ../main.tf
        ;;
    esac

    terraform init
    terraform $test_action -parallelism=1 -auto-approve 2>&1 | tee test_prepare.log
    exit_code=${PIPESTATUS[0]}
    check_errors $test_action 1 $exit_code test_prepare.log
}

test_cleanup() {
     test_prepare serialized destroy
}

#
# actual tests
#

test_apply() {
    local test_name=${1:-apply}
    local thrds=${2:-20}

    local logfile="test_${test_name}.log"

    terraform apply -parallelism="$thrds" -auto-approve 2>&1 | tee "$logfile"
    exit_code=${PIPESTATUS[0]}
    check_errors apply "$thrds" "$exit_code" "$logfile"
}

test_destroy() {
    local test_name=${1:-apply}
    local thrds=${2:-20}

    local logfile="test_${test_name}.log"

    terraform destroy -parallelism="$thrds" -auto-approve 2>&1 | tee "$logfile"
    exit_code=${PIPESTATUS[0]}
    check_errors destroy "$thrds" "$exit_code" "$logfile"
}

#
# error status check / alerting
#

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