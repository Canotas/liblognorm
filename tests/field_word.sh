#!/bin/bash
# Tests for the "word" parser (matches a sequence of non-whitespace chars)
# added 2026-03-19 (TC-5)
# This file is part of the liblognorm project, released under ASL 2.0
. $srcdir/exec.sh

test_def $0 "word parser"

add_rule 'version=2'
add_rule 'rule=:action=%action:word% user=%user:word%'

execute 'action=login user=alice'
assert_output_json_eq '{ "action": "login", "user": "alice" }'

execute 'action=LOGOUT user=bob123'
assert_output_json_eq '{ "action": "LOGOUT", "user": "bob123" }'

# mismatch: second word missing
execute 'action=login user='
assert_output_json_eq '{ "originalmsg": "action=login user=", "unparsed-data": "action=login user=" }'

cleanup_tmp_files
