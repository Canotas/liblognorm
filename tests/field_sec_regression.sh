#!/bin/bash
# Security regression tests for SEC-1 through SEC-5 fixes.
# These tests ensure that previously out-of-bounds inputs are handled
# safely and do not crash the normalizer.
# added 2026-03-19 (TC-3)
# This file is part of the liblognorm project, released under ASL 2.0
. $srcdir/exec.sh

test_def $0 "security regression tests"

# SEC-1: Checkpoint LEA multi-colon loop — value ending at buffer boundary
add_rule 'version=2'
add_rule 'rule=:%f:checkpoint-lea%'

# time value ending exactly at buffer boundary
execute 'ts: 23:59:59;'
assert_output_json_eq '{ "f": { "ts": "23:59:59" } }'

# single trailing colon — should parse cleanly without OOB read
execute 'key: val:;'
assert_output_json_eq '{ "f": { "key": "val:" } }'

reset_rules

# SEC-2: Checkpoint LEA quoted-value — closing quote at buffer boundary
add_rule 'version=2'
add_rule 'rule=:%f:checkpoint-lea%'

execute 'msg: "end";'
assert_output_json_eq '{ "f": { "msg": "end" } }'

# quoted value with no trailing fields
execute 'msg: "only";'
assert_output_json_eq '{ "f": { "msg": "only" } }'

reset_rules

# SEC-4: op-quoted-string — escape at very end of input
add_rule 'version=2'
add_rule 'rule=:%f:op-quoted-string%'

execute '"normal"'
assert_output_json_eq '{ "f": "normal" }'

# backslash before closing quote
execute '"abc\"def"'
assert_output_json_eq '{ "f": "abc\"def" }'

# SEC-5: strrev on empty string — should not crash
add_rule 'version=2'
add_rule 'rule=:%f:number%'

execute '0'
assert_output_json_eq '{ "f": "0" }'

cleanup_tmp_files
