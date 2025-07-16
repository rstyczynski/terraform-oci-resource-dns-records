#!/bin/bash

#
# tools
# 
function log() {
    awk 'BEGIN { spinner="|/-\\"; i=0 } { print >> "'"$logfile"'"; printf "\r%c", substr(spinner, i%4+1, 1); fflush(); i++ } END { print "" }'
}
#
# test preparation and cleaning
#

test_session() {
    test_session=$1
}

test_register() {
    test_name=${1:-default}
    test_type=${2:-regular}

    #
    # prepare test environment
    #
    logdir="logs/$test_session"
    mkdir -p $logdir
    logfile="$logdir/test_${test_name}.log"

    echo "" | tee -a "$logfile"
    echo "--------------------------------" | tee -a "$logfile"
    echo "Performing test $test_name (please wait...)" | tee -a "$logfile"
    echo "" | tee -a "$logfile"
}

test_prepare() {
    # test_name=${1:-default}

    # test_type=${2:-regular}
    test_action=${3:-destroy}
    test_state=${4:-prepare}

    #
    # copy module code to temporary module directory
    #
    mkdir -p .module
    cp ../*.tf .module/ 

    if declare -f test_prepare_support > /dev/null; then
        echo "Preparing test environment for $test_name with action $test_action and state $test_state of type $test_type"
        test_prepare_support "$test_name" "$test_action" "$test_state" "$test_type"
    fi

    #
    # prepare test environment
    #

    mkdir -p .state
    case "$test_state" in
    prepare)
        # env > "$logdir/test_${test_name}_env.log"
        local logfile="$logdir/test_${test_name}_prepare.log"
        terraform init -no-color 2>&1 | log
        terraform $test_action -no-color -parallelism=1 -auto-approve 2>&1 | log
        exit_code=${PIPESTATUS[0]}
        #check_errors $test_action 1 $exit_code "$logfile" Preparation 
        ;;
    cleanup)
        local logfile="$logdir/test_${test_name}_cleanup.log"
        terraform $test_action -no-color -parallelism=1 -auto-approve 2>&1 | log
        exit_code=${PIPESTATUS[0]}
        #check_errors $test_action 1 $exit_code "$logfile" Cleanup
        ;;
    esac
}

test_cleanup() {
    
    if [ -z "$test_name" ]; then
        echo "Error: test_prepare was not run => test_name is not set."
        return 1
    fi

    test_type=serialized
    test_prepare destroy cleanup
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
    echo "log file=$logfile" | tee -a "$logfile"

    if [ "$test_type" = "negative" ]; then
        if [ "$status" -eq 0 ]; then
            echo "status=$status FAILED ❌ (unexpected success in negative test)" | tee -a "$logfile"
        else
            echo "status=$status PASSED ✅ (expected failure in negative test)" | tee -a "$logfile"
        fi
    else
        if [ "$status" -eq 0 ]; then
            echo "status=$status PASSED ✅" | tee -a "$logfile"
        else
            echo "status=$status FAILED ❌" | tee -a "$logfile"
        fi
    fi
    echo "--------------------------------" | tee -a "$logfile"
    echo "" | tee -a "$logfile"
}

function test_report() {
    local filter_state="${1:-all}"  # "SUCCESS", "FAILED", or "all"
    local show_all="${2:-test}"      # "all" to show all, "test" to filter out prepare/cleanup

    # Echo test report with timestamp and current directory basename
    local timestamp
    timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
    local report_log="$logdir/report.log"
    local symlink="report.log"
    local current_dir
    upper_dir=$(basename "$(cd ..; pwd)")
    current_dir=$(basename "$PWD")

    # Remove old symlink if exists and create new one
    ln -sf "$report_log" "$symlink"

    echo
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
    grep "status=" $logdir/* | while IFS=: read -r logfile rest; do
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
    done < <(grep "status=" $logdir/*)

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

#
# asserts
#

# Assert that a file contains a given pattern
assert_file_contains() {
    local file="$1"
    local pattern="$2"
    local message="${3:-Expected pattern not found: $pattern}"
    local show="$4"

    if grep -q "$pattern" "$file"; then
        echo "✅ pattern '$pattern' found as expected"
        if [[ "$show" == "show" ]]; then
            grep "$pattern" "$file"
        fi
    else
        echo "❌ $message"
    fi
}

# Assert that a file does not contain a given pattern
function assert_file_lacks() {
    local file="$1"
    local pattern="$2"
    local message="${3:-Unexpected pattern found: $pattern}"
    local show="$4"

    if grep -q "$pattern" "$file"; then
        echo "❌ $message"
        if [[ "$show" == "show" ]]; then
            grep "$pattern" "$file"
        fi
    else
        echo "✅ pattern '$pattern' not found as expected"
    fi
}

#
# waiting
#


wait_with_progress() {
    local duration=$1
    local i=0
    local increment=$((100 / duration))
    local progress=0

    echo -n "Waiting for $duration seconds (press any key to cancel): ["
    while [ $i -lt $duration ]; do
        # Check for key press with a 1-second timeout
        if read -t 1 -n 1 key; then
            echo "] Canceled by user"
            return
        fi
        i=$((i + 1))
        progress=$((progress + increment))
        printf "#"
    done
    echo "] 100%"
}