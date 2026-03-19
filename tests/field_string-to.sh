#!/bin/bash
# added 2026-03-19
# This file is part of the liblognorm project, released under ASL 2.0
. $srcdir/exec.sh

test_def $0 "string-to field (parse up to delimiter string)"

reset_rules
add_rule 'version=2'
add_rule 'rule=:%f:string-to:END%END'

execute 'helloEND'
assert_output_json_eq '{"f": "hello"}'

execute 'hello worldEND'
assert_output_json_eq '{"f": "hello world"}'

# multi-char delimiter
reset_rules
add_rule 'version=2'
add_rule 'rule=:%f:string-to:::% :: %g:word%'

execute 'value :: key'
assert_output_json_eq '{"f": "value", "g": "key"}'

# mismatch: delimiter not found
reset_rules
add_rule 'version=2'
add_rule 'rule=:%f:string-to:END%END'

execute 'no delimiter here'
assert_output_json_eq '{"originalmsg": "no delimiter here", "unparsed-data": "no delimiter here"}'

cleanup_tmp_files
