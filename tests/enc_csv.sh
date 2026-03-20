#!/bin/bash
# Tests for CSV encoder output
# added 2026-03-20
. $srcdir/exec.sh

test_def $0 "CSV encoder basic output"

reset_rules
add_rule 'version=2'
add_rule 'rule=:host=%host:word% user=%user:word%'

# CSV encoder requires -E to specify field order
echo 'host=myserver user=alice' | $cmd $ln_opts -r tmp.rulebase -e csv -E 'host,user' > test.out
echo "Out:"
cat test.out

# Output should be two quoted CSV fields
assert_output_contains '"myserver","alice"'

cleanup_tmp_files
