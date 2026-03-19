#!/bin/bash
# added 2026-03-19
# This file is part of the liblognorm project, released under ASL 2.0
. $srcdir/exec.sh

test_def $0 "XML parser"
add_rule 'version=2'
add_rule 'rule=:%field:xml%'

# Basic XML: single root element with a child key/value
execute '<root><key>value</key></root>'
assert_output_json_eq '{ "field": { "key": "value" } }'

# Basic XML: multiple child elements
execute '<root><a>1</a><b>2</b></root>'
assert_output_json_eq '{ "field": { "a": "1", "b": "2" } }'

# Basic XML: self-closing root (no children, empty text)
execute '<root></root>'
assert_output_json_eq '{ "field": { } }'

# XML with an attribute on the root element — the parser does not
# extract attributes, so the child element value is still accessible
execute '<root id="42"><key>value</key></root>'
assert_output_json_eq '{ "field": { "key": "value" } }'

# XML with an attribute on a child element — attribute is ignored,
# text content of the child is captured
execute '<root><item type="info">hello</item></root>'
assert_output_json_eq '{ "field": { "item": "hello" } }'

# Nested elements: the outer child becomes a JSON object, the inner
# leaf becomes a string inside it
execute '<root><outer><inner>deep</inner></outer></root>'
assert_output_json_eq '{ "field": { "outer": { "inner": "deep" } } }'

# Two levels of nesting with sibling leaves
execute '<root><parent><child1>foo</child1><child2>bar</child2></parent></root>'
assert_output_json_eq '{ "field": { "parent": { "child1": "foo", "child2": "bar" } } }'

# XML preceded by non-XML content must fail (parser requires '<' at offset)
execute 'prefix <root><key>value</key></root>'
assert_output_json_eq '{ "originalmsg": "prefix <root><key>value<\/key><\/root>", "unparsed-data": "prefix <root><key>value<\/key><\/root>" }'

# Malformed XML: unclosed tag — must fail gracefully, no crash
execute '<root><key>value</key>'
assert_output_json_eq '{ "originalmsg": "<root><key>value<\/key>", "unparsed-data": "<root><key>value<\/key>" }'

# Malformed XML: mismatched tags — must fail gracefully
execute '<root><key>value</wrong></root>'
assert_output_json_eq '{ "originalmsg": "<root><key>value<\/wrong><\/root>", "unparsed-data": "<root><key>value<\/wrong><\/root>" }'

# Malformed XML: no root element at all — must fail gracefully
execute 'not xml at all'
assert_output_json_eq '{ "originalmsg": "not xml at all", "unparsed-data": "not xml at all" }'

cleanup_tmp_files
