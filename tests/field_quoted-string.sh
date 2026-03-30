#!/bin/bash
# added 2026-03-19
# This file is part of the liblognorm project, released under ASL 2.0
. $srcdir/exec.sh

test_def $0 "quoted-string field (strictly quoted strings)"

reset_rules
add_rule 'version=2'
add_rule 'rule=:a %f:quoted-string% b'

execute 'a "hello" b'
assert_output_json_eq '{"f": "\"hello\""}'

execute 'a "hello world" b'
assert_output_json_eq '{"f": "\"hello world\""}'

# quoted-string requires opening quote - bare word should not match
reset_rules
add_rule 'version=2'
add_rule 'rule=:%f:quoted-string%%rest:rest%'

execute '"quoted"'
assert_output_json_eq '{"f": "\"quoted\"", "rest": ""}'

execute '"with spaces inside"'
assert_output_json_eq '{"f": "\"with spaces inside\"", "rest": ""}'

# mismatch: no opening quote
execute 'notquoted'
assert_output_json_eq '{"originalmsg": "notquoted", "unparsed-data": "notquoted"}'

cleanup_tmp_files
