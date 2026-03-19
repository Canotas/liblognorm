#!/bin/bash
# added 2026-03-19
# This file is part of the liblognorm project, released under ASL 2.0
. $srcdir/exec.sh

test_def $0 "word field (space-delimited token)"

reset_rules
add_rule 'version=2'
add_rule 'rule=:a %f:word% b'

execute 'a hello b'
assert_output_json_eq '{"f": "hello"}'

# word stops at first space
reset_rules
add_rule 'version=2'
add_rule 'rule=:%f:word% %g:word%'

execute 'first second'
assert_output_json_eq '{"f": "first", "g": "second"}'

# word at end of string
reset_rules
add_rule 'version=2'
add_rule 'rule=:prefix %f:word%'

execute 'prefix lastword'
assert_output_json_eq '{"f": "lastword"}'

# mismatch: starts with space (empty word)
execute 'prefix '
assert_output_json_eq '{"originalmsg": "prefix ", "unparsed-data": ""}'

cleanup_tmp_files
