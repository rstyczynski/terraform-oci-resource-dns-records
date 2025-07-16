#!/bin/bash

# load supporting library
source bin/unit_tests.sh

#
# actual tests
#

test_prepare_support() {
    local test_name="$1"
    local test_action="$2"
    local test_state="$3"
    local test_type="$4"

    #
    # Start of section: Additional setup can be added here if needed
    #

    # edit TF code to turn on/off serialization
    case $test_type in
    regular)
        sed -i '' 's/^\([[:space:]]*\)depends_on/#depends_on/' .module/main.tf
        ;;
    serialized)
        sed -i '' 's/^\([[:space:]]*\)#depends_on/depends_on/' .module/main.tf
        ;;
    esac
    
    #
    # End of section: Additional setup can be added here if needed
    #
}

test_apply() {
    [ -z "$test_name" ] && { echo "Error: test_prepare was not run => test_name is not set."; return 1; }

    local test_threads=${1:-20}
    local test_type=${2:-regular}

    terraform apply -no-color -parallelism="$test_threads" -auto-approve 2>&1 | tee "$logfile"
    exit_code=${PIPESTATUS[0]}
    check_errors apply "$test_threads" "$exit_code" "$logfile" Test "$test_type"
}

test_destroy() {
    [ -z "$test_name" ] && { echo "Error: test_prepare was not run => test_name is not set."; return 1; }

    local test_threads=${1:-20}
    local test_type=${2:-regular}

    terraform  destroy -no-color -parallelism="$test_threads" -auto-approve 2>&1 | tee "$logfile"
    exit_code=${PIPESTATUS[0]}
    check_errors destroy "$test_threads" "$exit_code" "$logfile" Test "$test_type"
}

#
# test sequences
#


test_suite() {
    # test 1
    test_prepare test_1 regular destroy >/dev/null
    
    test_apply 20 negative

    test_cleanup >/dev/null

    # test 2
    test_prepare test_2 regular apply >/dev/null

    test_destroy 20 negative
    
    test_cleanup >/dev/null

    # test 3
    test_prepare test_3a serialized destroy >/dev/null

    test_apply 20
    
    test_cleanup >/dev/null

    test_prepare test_3b serialized apply >/dev/null
    test_destroy 20
    test_cleanup >/dev/null

    # test 4
    test_prepare test_4a regular destroy >/dev/null
    test_apply 1
    test_cleanup >/dev/null

    test_prepare test_4b regular apply >/dev/null
    test_destroy 1
    test_cleanup >/dev/null

    # test 5
    test_prepare test_5 regular destroy >/dev/null
    cat >> .module/providers.tf <<EOF
provider "oci" {
  disable_auto_retries=false
  retry_duration_seconds = 1800
}
EOF
    export TF_LOG=debug
    export OCI_GO_SDK_DEBUG=v
    test_apply 20 negative

    assert_file_contains "$logfile" 'operation attempt' '' 
    assert_file_contains "$logfile" 'Time elapsed for retry:' '' 
    
    test_cleanup >/dev/null
    unset TF_LOG
    unset OCI_GO_SDK_DEBUG

    #
    # final report
    #
    test_report
}

# configure module parameters
export TF_VAR_rrsets=$(sed 's/acme.org/acme.org/' data/dataset1.acme)
export TF_VAR_zone_name_or_id="ocid1.dns-zone.oc1..aaaaaaaarh7borfqosuhymrv6pjh2m7nqhj27ctaqgtyctee2zpyc67xo6ta"

test_session=${1:-$(date +"%Y-%m-%d_%H-%M-%S")}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    test_suite
fi
