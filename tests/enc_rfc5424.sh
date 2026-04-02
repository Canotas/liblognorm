#!/bin/bash
# Tests for cee-syslog (RFC 5424 / CEE structured-data) encoder
# added 2026-03-20
. $srcdir/exec.sh

test_def $0 "cee-syslog encoder basic output"

reset_rules
add_rule 'version=2'
add_rule 'rule=:host=%host:word% user=%user:word%'

echo 'host=myserver user=alice' | $cmd $ln_opts -r tmp.rulebase -e cee-syslog > test.out
echo "Out:"
cat test.out

# Output should be a structured-data element starting with [cee@115
assert_output_contains '[cee@115'
assert_output_contains 'host="myserver"'
assert_output_contains 'user="alice"'

cleanup_tmp_files
