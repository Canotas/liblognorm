#!/bin/bash
# Tests for the "quoted-string" parser (matches a double-quoted string)
# added 2026-03-19 (TC-5)
# This file is part of the liblognorm project, released under ASL 2.0
. $srcdir/exec.sh

test_def $0 "quoted-string parser"

add_rule 'version=2'
add_rule 'rule=:msg=%msg:quoted-string%'

execute 'msg="hello world"'
assert_output_json_eq '{ "msg": "hello world" }'

execute 'msg="with \"escaped\" quotes"'
assert_output_json_eq '{ "msg": "with \"escaped\" quotes" }'

# empty quoted string
execute 'msg=""'
assert_output_json_eq '{ "msg": "" }'

# mismatch: no opening quote
execute 'msg=hello world'
assert_output_json_eq '{ "originalmsg": "msg=hello world", "unparsed-data": "msg=hello world" }'

cleanup_tmp_files
