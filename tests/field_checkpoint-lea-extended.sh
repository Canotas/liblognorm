#!/bin/bash
# Extended tests for the checkpoint-lea parser covering multi-colon values,
# quoted values, and edge cases (TC-2, covers SEC-1 and SEC-2 regression).
# added 2026-03-19
# This file is part of the liblognorm project, released under ASL 2.0
. $srcdir/exec.sh

test_def $0 "Checkpoint LEA extended tests"
add_rule 'version=2'
add_rule 'rule=:%f:checkpoint-lea%'

# basic key:value
execute 'action: accept; src: 10.0.0.1;'
assert_output_json_eq '{ "f": { "action": "accept", "src": "10.0.0.1" } }'

# multiple fields
execute 'proto: tcp; sport: 1234; dport: 80; flags: RST-ACK;'
assert_output_json_eq '{ "f": { "proto": "tcp", "sport": "1234", "dport": "80", "flags": "RST-ACK" } }'

# quoted value
execute 'msg: "hello world"; src: 1.2.3.4;'
assert_output_json_eq '{ "f": { "msg": "hello world", "src": "1.2.3.4" } }'

# quoted value with escaped quote
execute 'msg: "say \"hi\""; code: 42;'
assert_output_json_eq '{ "f": { "msg": "say \"hi\"", "code": "42" } }'

# value containing a colon (multi-colon key)
execute 'time: 12:34:56; src: 10.0.0.1;'
assert_output_json_eq '{ "f": { "time": "12:34:56", "src": "10.0.0.1" } }'

# empty value
execute 'key: ; src: 1.2.3.4;'
assert_output_json_eq '{ "f": { "key": "", "src": "1.2.3.4" } }'

cleanup_tmp_files
