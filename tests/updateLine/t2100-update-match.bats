#!/usr/bin/env bats

load temp

@test "update with nonmatching pattern returns 1" {
    UPDATE="foo=new"
    run updateLine --update-match "foosball=never" --replacement new "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "update with literal-like pattern updates first matching line" {
    run updateLine --update-match "foo=h.*" --replacement "foo=new" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = 'sing/e=wha\ever
foo=bar
foo=new
# SECTION
foo=hi' ]
}

@test "update with anchored pattern updates first matching line" {
    run updateLine --update-match "^fo\+=[ghi].*$" --replacement "foo=new" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = 'sing/e=wha\ever
foo=bar
foo=new
# SECTION
foo=hi' ]
}

@test "update with pattern containing forward and backslash updates first matching line" {
    run updateLine --update-match '^.*/.=.*\\.*' --replacement 'foo=/e\\' "$FILE"
    [ $status -eq 0 ]
    [ "$output" = 'foo=/e\
foo=bar
foo=hoo bar baz
# SECTION
foo=hi' ]
}
