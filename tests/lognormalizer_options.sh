#!/bin/bash
# Tests for lognormalizer -o context options
# added 2026-03-20
. $srcdir/exec.sh

test_def $0 "lognormalizer -o context options"

reset_rules
add_rule 'version=2'
add_rule 'rule=test:host=%host:word% user=%user:word%'

# Test addOriginalMsg: original input should appear under "originalmsg" key
echo 'host=myserver user=alice' | $cmd $ln_opts -r tmp.rulebase -e json -oaddOriginalMsg > test.out
echo "Out (addOriginalMsg):"
cat test.out
assert_output_contains '"originalmsg"'
assert_output_contains 'host=myserver user=alice'

# Test addRule: matching rule mockup should appear in metadata
echo 'host=myserver user=alice' | $cmd $ln_opts -r tmp.rulebase -e json -oaddRule > test.out
echo "Out (addRule):"
cat test.out
assert_output_contains '"metadata"'
assert_output_contains '"rule"'
assert_output_contains '"mockup"'

# Test addRuleLocation: rule file and line should appear in metadata
echo 'host=myserver user=alice' | $cmd $ln_opts -r tmp.rulebase -e json -oaddRuleLocation > test.out
echo "Out (addRuleLocation):"
cat test.out
assert_output_contains '"metadata"'
assert_output_contains '"location"'
assert_output_contains '"file"'
assert_output_contains '"line"'

cleanup_tmp_files
