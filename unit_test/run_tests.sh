#!/bin/bash

export TF_VAR_rrsets=$(sed 's/acme.org/acme.org/' data/dataset1.acme)
export TF_VAR_zone_name_or_id="ocid1.dns-zone.oc1..aaaaaaaarh7borfqosuhymrv6pjh2m7nqhj27ctaqgtyctee2zpyc67xo6ta"

# test 1
test_prepare test_1 regular destroy
test_apply 20 negative
test_cleanup

# test 2
test_prepare test_2 regular apply 
test_destroy 20 negative
test_cleanup

# test 3
test_prepare test_3a serialized destroy
test_apply 20
test_cleanup

test_prepare test_3b serialized apply
test_destroy 20
test_cleanup

# test 4
test_prepare test_4a regular destroy 
test_apply 1
test_cleanup

test_prepare test_4b regular apply
test_destroy 1
test_cleanup

# report
test_report all
