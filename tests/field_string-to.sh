#!/bin/bash
# Tests for the "string-to" parser (matches everything up to a given substring)
# added 2026-03-19 (TC-5)
# This file is part of the liblognorm project, released under ASL 2.0
. $srcdir/exec.sh

test_def $0 "string-to parser"

add_rule 'version=2'
add_rule 'rule=:src=%src:string-to:->% -> %dst:string-to: %'

execute 'src=1.2.3.4 -> dst=5.6.7.8'
assert_output_json_eq '{ "src": "src=1.2.3.4 ", "dst": "dst=5.6.7.8" }'

# no match: terminator not found
execute 'src=1.2.3.4 without arrow'
assert_output_json_eq '{ "originalmsg": "src=1.2.3.4 without arrow", "unparsed-data": "src=1.2.3.4 without arrow" }'

cleanup_tmp_files
