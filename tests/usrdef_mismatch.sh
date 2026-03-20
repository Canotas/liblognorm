#!/bin/bash
# Test that a custom type field mismatch is handled cleanly (TC-11, #115)
# When the input does not match a user-defined type, lognorm must produce
# an "unparsed-data" result rather than crashing or producing garbage.
# added 2026-03-20
. $srcdir/exec.sh

test_def $0 "custom type mismatch produces unparsed-data"
add_rule 'version=2'
add_rule 'type=@hex-byte:%f1:hexnumber{"maxval": "255"}%'
add_rule 'rule=:prefix %.:@hex-byte% suffix'

# This matches: 0xff is a valid hex byte
execute 'prefix 0xff suffix'
assert_output_json_eq '{ "f1": "0xff" }'

# This does not match: "notahex" is not a hex number
# Expect unparsed-data and originalmsg, no crash
execute 'prefix notahex suffix'
assert_output_contains '"unparsed-data"'
assert_output_contains '"originalmsg"'

cleanup_tmp_files
