#!/bin/bash
# added 2015-06-18 by Rainer Gerhards
# This file is part of the liblognorm project, released under ASL 2.0
. $srcdir/exec.sh

test_def $0 "Checkpoint LEA parser"
add_rule 'version=2'
add_rule 'rule=:%f:checkpoint-lea%'

execute 'tcp_flags: RST-ACK; src: 192.168.0.1;'
assert_output_json_eq '{ "f": { "tcp_flags": "RST-ACK", "src": "192.168.0.1" } }'

# SEC-1 regression: message ending with a bare colon must not crash;
# the parser cannot find a value or semicolon terminator and must fail
execute 'tcp_flags: RST-ACK; src:'
assert_output_json_eq '{ "originalmsg": "tcp_flags: RST-ACK; src:", "unparsed-data": "tcp_flags: RST-ACK; src:" }'

# SEC-2 regression: input starting with a colon gives zero-length field
# name; the parser must reject this gracefully without reading before the
# buffer start
execute ': value;'
assert_output_json_eq '{ "originalmsg": ": value;", "unparsed-data": ": value;" }'


cleanup_tmp_files

