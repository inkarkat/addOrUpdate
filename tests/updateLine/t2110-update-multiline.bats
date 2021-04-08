#!/usr/bin/env bats

load temp

@test "update with literal-like pattern updates first matching line with multiple lines" {
    run updateLine --replacement 'foo=multi\nline' --update-match "foo=h.*" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "sing/e=wha\\ever
foo=bar
foo=multi
line
# SECTION
foo=hi" ]
}
