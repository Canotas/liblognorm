#!/bin/bash
# added 2025-05-06 by KGuillemot
# This file is part of the liblognorm project, released under ASL 2.0
. $srcdir/exec.sh

test_def $0 "float field"
add_rule 'version=2'
add_rule 'rule=:%test:op-quoted-string%%rest:rest%'
execute 'abcd efgh'
assert_output_json_eq '{"test": "abcd", "rest": " efgh"}'

reset_rules

add_rule 'version=2'
add_rule 'rule=:%test:op-quoted-string%'
execute '"abcd efgh"'
assert_output_json_eq '{"test": "abcd efgh"}'

execute '"abcd\\\"efgh"'
assert_output_json_eq '{"test": "abcd\\\"efgh"}'

reset_rules

add_rule 'version=2'
add_rule 'rule=:%test:op-quoted-string%%rest:rest%'

execute '"abcd\"efgh"ijkl'
assert_output_json_eq '{"test": "abcd\"efgh", "rest": "ijkl"}'

execute '"abcd\\"efgh"'
assert_output_json_eq '{"test": "abcd\\", "rest": "efgh\""}'

execute '"abcd\\\"efgh"'
assert_output_json_eq '{"test": "abcd\\\"efgh", "rest": ""}'

# Unclosed string (last quote is escaped)
execute '"abcd efgh\"'
assert_output_json_eq '{ "originalmsg": "\"abcd efgh\\\"", "unparsed-data": "\"abcd efgh\\\"" }'

reset_rules

add_rule 'version=2'
add_rule 'rule=:%test:op-quoted-string% %test2:op-quoted-string%'

execute '"abcd\"efgh\\" "ijkl\\\"mnop"'
assert_output_json_eq '{ "test2": "ijkl\\\"mnop", "test": "abcd\"efgh\\" }'

execute '"abcd\"efgh" "ijkl'
assert_output_json_eq '{ "originalmsg": "\"abcd\\\"efgh\" \"ijkl", "unparsed-data": "\"ijkl" }'

# Edge case: empty quoted string
reset_rules
add_rule 'version=2'
add_rule 'rule=:%test:op-quoted-string%'
execute '""'
assert_output_json_eq '{ "test": "" }'

# Edge case: consecutive escape sequences "a\\\\b" — two real backslashes
# The shell passes "a\\b" (each \\ becomes one \), so the parser sees a\\b
execute '"a\\\\b"'
assert_output_json_eq '{ "test": "a\\\\b" }'

# Edge case: unicode inside quoted string
execute '"café"'
assert_output_json_eq '{ "test": "café" }'

# Edge case: long quoted string (well above typical buffer boundaries)
execute '"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"'
assert_output_json_eq '{ "test": "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" }'

# Edge case: quoted string followed by space and rest parser
reset_rules
add_rule 'version=2'
add_rule 'rule=:%test:op-quoted-string% %tail:rest%'
execute '"hello world" and more text'
assert_output_json_eq '{ "test": "hello world", "tail": "and more text" }'

cleanup_tmp_files

