#!/bin/bash

#
# test preparation and cleaning
#

test_prepare() {
    test_name=${1:-default}

    local test_type=${2:-regular}
    local test_action=${3:-destroy}
    local test_state=${4:-prepare}

    case $test_type in
    regular)
        sed -i '' 's/^\([[:space:]]*\)depends_on/#depends_on/' ../main.tf
        ;;
    serialized)
        sed -i '' 's/^\([[:space:]]*\)#depends_on/depends_on/' ../main.tf
        ;;
    esac
    terraform fmt ../main.tf

    mkdir -p logs
    case "$test_state" in
    prepare)
        local logfile="test_${test_name}_prepare.log"
        terraform init -no-color 
        terraform $test_action -no-color -parallelism=1 -auto-approve 2>&1 | tee "logs/$logfile"
        exit_code=${PIPESTATUS[0]}
        check_errors $test_action 1 $exit_code "logs/$logfile" Preparation
        ;;
    cleanup)
        local logfile="test_${test_name}_cleanup.log"
        terraform $test_action -no-color -parallelism=1 -auto-approve 2>&1 | tee "logs/$logfile"
        exit_code=${PIPESTATUS[0]}
        check_errors $test_action 1 $exit_code "logs/$logfile" Cleanup
        ;;
    esac

}

test_cleanup() {
    
    if [ -z "$test_name" ]; then
        echo "Error: test_prepare was not run => test_name is not set."
        return 1
    fi

    test_prepare "$test_name" serialized destroy cleanup
}

#
# actual tests
#

test_apply() {
    local thrds=${1:-20}
    local test_type=${2:-regular}

    local logfile="test_${test_name}.log"

    if [ -z "$test_name" ]; then
        echo "Error: test_prepare was not run => test_name is not set."
        return 1
    fi

    terraform apply -no-color -parallelism="$thrds" -auto-approve 2>&1 | tee "logs/$logfile"
    exit_code=${PIPESTATUS[0]}
    check_errors apply "$thrds" "$exit_code" "logs/$logfile" Test "$test_type"
}

test_destroy() {
    local thrds=${1:-20}
    local test_type=${2:-regular}

    local logfile="test_${test_name}.log"

    if [ -z "$test_name" ]; then
        echo "Error: test_prepare was not run => test_name is not set."
        return 1
    fi

    terraform  destroy -no-color -parallelism="$thrds" -auto-approve 2>&1 | tee "logs/$logfile"
    exit_code=${PIPESTATUS[0]}
    check_errors destroy "$thrds" "$exit_code" "logs/$logfile" Test "$test_type"
}

#
# error status check / alerting
#

function check_errors() {
    local operation="$1"
    local parallelism="$2"
    local status="$3"
    local logfile="$4"
    local test_state=${5:-Test}
    local test_type=${6:-regular}

    echo "" | tee -a "$logfile"
    echo "--------------------------------" | tee -a "$logfile"
    echo "$test_state status for test_name=$test_name" | tee -a "$logfile"
    echo "" | tee -a "$logfile"
    echo "operation=$operation" | tee -a "$logfile"
    echo "parallelism=$parallelism" | tee -a "$logfile"

    if [ "$test_type" = "negative" ]; then
        if [ "$status" -eq 0 ]; then
            echo "status=$status ❌ (unexpected success in negative test)" | tee -a "$logfile"
            echo "info=Error was expected but operation succeeded." | tee -a "$logfile"
        else
            echo "status=$status ✅ (expected failure in negative test)" | tee -a "$logfile"
            if grep -q "409" "$logfile" 2>/dev/null; then
                echo "info=409 Conflict detected! 🚨" | tee -a "$logfile"
            else
                echo "info=Check above for error details." | tee -a "$logfile"
            fi
        fi
    else
        if [ "$status" -eq 0 ]; then
            echo "status=$status ✅" | tee -a "$logfile"
        else
            echo "status=$status ❌" | tee -a "$logfile"
            if grep -q "409" "$logfile" 2>/dev/null; then
                echo "info=409 Conflict detected! 🚨" | tee -a "$logfile"
            else
                echo "info=Check above for error details." | tee -a "$logfile"
            fi
        fi
    fi
    echo "--------------------------------" | tee -a "$logfile"
    echo "" | tee -a "$logfile"
}