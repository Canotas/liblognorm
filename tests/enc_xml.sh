#!/bin/bash
# Tests for XML encoder output
# added 2026-03-20
. $srcdir/exec.sh

test_def $0 "XML encoder basic output"

reset_rules
add_rule 'version=2'
add_rule 'rule=:host=%host:word% user=%user:word%'

echo 'host=myserver user=alice' | $cmd $ln_opts -r tmp.rulebase -e xml > test.out
echo "Out:"
cat test.out

# Output should be wrapped in <event>...</event> tags
assert_output_contains '<event>'
assert_output_contains '</event>'
assert_output_contains '<name>host</name>'
assert_output_contains '<name>user</name>'

cleanup_tmp_files
