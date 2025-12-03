#!/bin/bash

#
# test preparation and cleaning
#

test_prepare() {
    test_name=${1:-default}

    local test_type=${2:-regular}
    local test_action=${3:-destroy}
    local test_state=${4:-prepare}

    #
    # copy module code to temporary module directory
    #
    mkdir -p .module
    cp ../*.tf .module/ 

    #
    # edit TF code to turn on/off serialization
    #
    case $test_type in
    regular)
        sed -i '' 's/^\([[:space:]]*\)depends_on/#depends_on/' .module/main.tf
        ;;
    serialized)
        sed -i '' 's/^\([[:space:]]*\)#depends_on/depends_on/' .module/main.tf
        ;;
    esac
    terraform fmt .module/main.tf >/dev/null 2>&1

    #
    # prepare test environment
    #
    mkdir -p logs
    mkdir -p .state
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
    echo "test_type=$test_type" | tee -a "$logfile"

    if [ "$test_type" = "negative" ]; then
        if [ "$status" -eq 0 ]; then
            test_result=1
            echo "status=$status FAILED ❌ (unexpected success in negative test)" | tee -a "$logfile"
            echo "info=Error was expected but operation succeeded." | tee -a "$logfile"
        else
            test_result=0
            echo "status=$status PASSED ✅ (expected failure in negative test)" | tee -a "$logfile"
            if grep -q "409" "$logfile" 2>/dev/null; then
                echo "info=409 Conflict detected! 🚨" | tee -a "$logfile"
            else
                echo "info=Check above for error details." | tee -a "$logfile"
            fi
        fi
    else
        if [ "$status" -eq 0 ]; then
            test_result=0
            echo "status=$status PASSED ✅" | tee -a "$logfile"
        else
            test_result=1
            echo "status=$status FAILED ❌" | tee -a "$logfile"
            if grep -q "409" "$logfile" 2>/dev/null; then
                echo "info=409 Conflict detected! 🚨" | tee -a "$logfile"
            else
                echo "info=Check above for error details." | tee -a "$logfile"
            fi
        fi
    fi
    echo "--------------------------------" | tee -a "$logfile"
    echo "" | tee -a "$logfile"
    return $test_result
}

function test_report() {
    local filter_state="${1:-all}"  # "SUCCESS", "FAILED", or "all"
    local show_all="${2:-test}"      # "all" to show all, "test" to filter out prepare/cleanup

    # Echo test report with timestamp and current directory basename
    local timestamp
    timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
    local report_log="logs/report-${timestamp}.log"
    local symlink="logs/report.log"
    local current_dir
    upper_dir=$(basename "$(cd ..; pwd)")
    current_dir=$(basename "$PWD")

    # Remove old symlink if exists and create new one
    ln -sf "$(basename "$report_log")" "$symlink"

    echo "TEST REPORT" | tee -a "$report_log"
    echo "--------------------------------" | tee -a "$report_log"
    echo "Terraform module: $upper_dir" | tee -a "$report_log"
    echo "Test suite:       $current_dir" | tee -a "$report_log"
    echo "Test date:        $timestamp" | tee -a "$report_log"
    echo | tee -a "$report_log"

    # Print table header
    printf "%-30s | %-40s\n" "name" "status" | tee -a "$report_log"
    printf "%-30s-+-%-40s\n" "$(printf '%.0s-' {1..30})" "$(printf '%.0s-' {1..40})" | tee -a "$report_log"

    # Extract and print name and status columns
    grep "status=" logs/* | while IFS=: read -r logfile rest; do
        # logfile is logs/test_3a_apply.log, extract test_3a_apply
        name=$(basename "$logfile" .log)
        # Optionally filter out prepare/cleanup unless show_all is set
        if [[ "$show_all" != "all" ]]; then
            if [[ "$name" == *prepare* || "$name" == *cleanup* ]]; then
                continue
            fi
        fi
        # rest is status=0 PASSED ✅, extract everything after first '='
        status=$(echo "$rest" | sed 's/^[^=]*=//')

        # Determine test state by Unicode mark
        # Success: contains "✅"
        # Failure: contains "❌"
        if echo "$status" | grep -q "✅"; then
            test_state="SUCCESS"
        elif echo "$status" | grep -q "❌"; then
            test_state="FAILED"
        else
            test_state="UNKNOWN"
        fi

        # Filter by test state if requested
        if [[ "$filter_state" == "all" || "$filter_state" == "$test_state" ]]; then
            printf "%-30s | %-40s\n" "$name" "$status" | tee -a "$report_log"
        fi
    done

    #
    # Summary report
    #
    total_tests=0
    failed_tests=0

    # Re-scan logs for status lines
    while IFS=: read -r logfile rest; do
        name=$(basename "$logfile" .log)
        if [[ "$show_all" != "all" ]]; then
            if [[ "$name" == *prepare* || "$name" == *cleanup* ]]; then
                continue
            fi
        fi
        status=$(echo "$rest" | sed 's/^[^=]*=//')
        ((total_tests++))
        if ! echo "$status" | grep -q "✅"; then
            ((failed_tests++))
        fi
    done < <(grep "status=" logs/*)

    echo | tee -a "$report_log"
    echo "--------------------------------" | tee -a "$report_log"
    if [[ $total_tests -eq 0 ]]; then
        echo "No tests found." | tee -a "$report_log"
    elif [[ $failed_tests -eq 0 ]]; then
        echo "ALL TESTS SUCCEEDED 🎉" | tee -a "$report_log"
        return 0
    else
        echo "SOME TESTS FAILED ($failed_tests of $total_tests) ❌" | tee -a "$report_log"
        return 1
    fi
}