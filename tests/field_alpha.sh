#!/bin/bash
# Tests for the "alpha" parser (matches a sequence of alpha-only chars)
# added 2026-03-19 (TC-5)
# This file is part of the liblognorm project, released under ASL 2.0
. $srcdir/exec.sh

test_def $0 "alpha parser"

add_rule 'version=2'
add_rule 'rule=:action=%action:alpha% code=%code:number%'

execute 'action=login code=42'
assert_output_json_eq '{ "action": "login", "code": "42" }'

execute 'action=LOGOUT code=0'
assert_output_json_eq '{ "action": "LOGOUT", "code": "0" }'

# mismatch: digits in alpha field
execute 'action=log1n code=5'
assert_output_json_eq '{ "originalmsg": "action=log1n code=5", "unparsed-data": "action=log1n code=5" }'

cleanup_tmp_files
