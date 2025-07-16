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

    test_phase=apply
    test_state=Test
    test_threads=${1:-20}
    test_type=${2:-regular}

    # Use stdbuf to force line buffering for real-time spinner feedback
    terraform apply -no-color -parallelism="$test_threads" -auto-approve 2>&1 | log
    exit_code=${PIPESTATUS[0]}
}

test_destroy() {
    [ -z "$test_name" ] && { echo "Error: test_prepare was not run => test_name is not set."; return 1; }

    local test_threads=${1:-20}
    local test_type=${2:-regular}

    terraform  destroy -no-color -parallelism="$test_threads" -auto-approve 2>&1 | log
    exit_code=${PIPESTATUS[0]}
    check_errors destroy "$test_threads" "$exit_code" "$logfile" Test "$test_type"
}

#
# test sequences
#


test_suite() {

    # 
    # preventive clean-up
    #
    unset TF_LOG
    unset OCI_GO_SDK_DEBUG
    unset OCI_SDK_DEFAULT_RETRY_ENABLED
    unset OCI_SDK_DEFAULT_CIRCUITBREAKER_ENABLED    

   #
    # test 1 - vanilla
    #
    test_register test_1_vanilla regular 
    
    test_prepare destroy 

    test_apply 20 
    check_errors "$test_phase" "$test_threads" "$exit_code" "$logfile" "$test_state" "$test_type"

    test_cleanup 

    #
    # test 1 - vanilla_debug
    #

    # wait to clear RPM tokens (hopefully)
    # wait_with_progress 65
    
    test_register test_1_vanilla_debug regular 

    test_prepare destroy 

    export TF_LOG=debug
    export OCI_GO_SDK_DEBUG=verbose
    test_apply 20
    
    check_errors "$test_phase" "$test_threads" "$exit_code" "$logfile" "$test_state" "$test_type"
    assert_file_contains "$logfile" 'operation attempt' '' 
    assert_file_contains "$logfile" 'Time elapsed for retry:' '' 
    
    test_cleanup 
    unset TF_LOG
    unset OCI_GO_SDK_DEBUG


    #
    # test 2 - vanilla_no_cb
    #

    # wait to clear RPM tokens (hopefully)
    # wait_with_progress 65
    
    test_register test_2_vanilla_no_cb regular  

    test_prepare destroy 

    export OCI_SDK_DEFAULT_CIRCUITBREAKER_ENABLED=FALSE
    test_apply 20  
    check_errors "$test_phase" "$test_threads" "$exit_code" "$logfile" "$test_state" "$test_type"

    test_cleanup 

    #
    # test 2 - vanilla_no_cb_debug
    #

    # wait to clear RPM tokens (hopefully)
    # wait_with_progress 65

    test_register test_2_vanilla_no_cb_debug regular 

    test_prepare destroy 

    export TF_LOG=debug
    export OCI_GO_SDK_DEBUG=verbose
    export OCI_SDK_DEFAULT_CIRCUITBREAKER_ENABLED=FALSE
    test_apply 20  

    check_errors "$test_phase" "$test_threads" "$exit_code" "$logfile" "$test_state" "$test_type"
    assert_file_contains "$logfile" 'operation attempt' '' 
    assert_file_lacks "$logfile" 'Time elapsed for retry:' '' 
    
    test_cleanup 
    unset TF_LOG
    unset OCI_GO_SDK_DEBUG
    unset OCI_SDK_DEFAULT_CIRCUITBREAKER_ENABLED

    #
    # test 3 - retry
    #
    test_register test_3_retry regular 
    
    test_prepare destroy 
    cat >> .module/providers.tf <<EOF
provider "oci" {
  retry_duration_seconds = 1800
}
EOF

    test_apply 20 
    check_errors "$test_phase" "$test_threads" "$exit_code" "$logfile" "$test_state" "$test_type"

    test_cleanup 

    #
    # test 3 - retry_debug
    #

    # wait to clear RPM tokens (hopefully)
    # wait_with_progress 65
    
    test_register test_3_retry_debug regular 

    test_prepare destroy 
    cat >> .module/providers.tf <<EOF
provider "oci" {
  retry_duration_seconds = 1800
}
EOF
    export TF_LOG=debug
    export OCI_GO_SDK_DEBUG=verbose
    test_apply 20
    
    check_errors "$test_phase" "$test_threads" "$exit_code" "$logfile" "$test_state" "$test_type"
    assert_file_contains "$logfile" 'operation attempt' '' 
    assert_file_contains "$logfile" 'Time elapsed for retry:' '' 
    
    test_cleanup 
    unset TF_LOG
    unset OCI_GO_SDK_DEBUG


    #
    # test 4 - retry_no_cb
    #
    test_register test_4_retry_no_cb regular 
    
    test_prepare destroy 
    cat >> .module/providers.tf <<EOF
provider "oci" {
  retry_duration_seconds = 1800
}
EOF
    export OCI_SDK_DEFAULT_CIRCUITBREAKER_ENABLED=FALSE
    test_apply 20 
    check_errors "$test_phase" "$test_threads" "$exit_code" "$logfile" "$test_state" "$test_type"

    test_cleanup 
    unset OCI_SDK_DEFAULT_CIRCUITBREAKER_ENABLED

    #
    # test 4 - retry_no_cb_debug
    #
    test_register test_4_retry_no_cb_debug regular 

    export TF_LOG=debug
    export OCI_GO_SDK_DEBUG=verbose
    export OCI_SDK_DEFAULT_CIRCUITBREAKER_ENABLED=FALSE
    test_prepare destroy 
    cat >> .module/providers.tf <<EOF
provider "oci" {
  retry_duration_seconds = 1800
}
EOF
    test_apply 20  
    check_errors "$test_phase" "$test_threads" "$exit_code" "$logfile" "$test_state" "$test_type"
    assert_file_contains "$logfile" 'operation attempt' '' 
    assert_file_contains "$logfile" 'Time elapsed for retry:' '' 
    
    test_cleanup 
    unset TF_LOG
    unset OCI_GO_SDK_DEBUG
    unset OCI_SDK_DEFAULT_CIRCUITBREAKER_ENABLED


    #
    # test 5 - no_retry
    #

    # wait to clear RPM tokens (hopefully)
    # wait_with_progress 65
    
    test_register test_5_no_retry regular  

    test_prepare destroy 
    cat >> .module/providers.tf <<EOF
provider "oci" {
  retry_duration_seconds = 0
}
EOF
    test_apply 20 negative 
    check_errors "$test_phase" "$test_threads" "$exit_code" "$logfile" "$test_state" "$test_type"

    test_cleanup 

    #
    # test 5 - no_retry_debug
    #

    # wait to clear RPM tokens (hopefully)
    # wait_with_progress 65

    test_register test_5_no_retry_debug regular 

    test_prepare destroy 
    cat >> .module/providers.tf <<EOF
provider "oci" {
    disable_auto_retries = true
    retry_duration_seconds = 0
}
EOF
    export TF_LOG=debug
    export OCI_GO_SDK_DEBUG=verbose
    test_apply 20 negative 

    check_errors "$test_phase" "$test_threads" "$exit_code" "$logfile" "$test_state" "$test_type"
    assert_file_contains "$logfile" 'operation attempt' '' 
    assert_file_lacks "$logfile" 'Time elapsed for retry:' '' 
    
    test_cleanup 
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
