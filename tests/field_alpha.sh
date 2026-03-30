#!/bin/bash
# added 2026-03-19
# This file is part of the liblognorm project, released under ASL 2.0
. $srcdir/exec.sh

test_def $0 "alpha field (alphabetic characters only)"

reset_rules
add_rule 'version=2'
add_rule 'rule=:a %f:alpha% b'

execute 'a hello b'
assert_output_json_eq '{"f": "hello"}'

# alpha stops at non-alpha character
reset_rules
add_rule 'version=2'
add_rule 'rule=:%f:alpha%%rest:rest%'

execute 'abcDEF123'
assert_output_json_eq '{"f": "abcDEF", "rest": "123"}'

execute 'hello world'
assert_output_json_eq '{"f": "hello", "rest": " world"}'

# mismatch: no alpha chars at start
execute '123abc'
assert_output_json_eq '{"originalmsg": "123abc", "unparsed-data": "123abc"}'

cleanup_tmp_files
