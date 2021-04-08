#!/usr/bin/env bats

load temp

@test "update with pattern matching full line uses REPLACEMENT" {
    run updateLine --update-match '^foo=h.*$' --replacement "ox=replaced" "$FILE"

    [ $status -eq 0 ]
    [ "$output" = 'sing/e=wha\ever
foo=bar
ox=replaced
# SECTION
foo=hi' ]
}

@test "update with pattern matching partial line uses REPLACEMENT just for match" {
    run updateLine --update-match 'oo=h[a-z]\+' --replacement "ox=replaced" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = 'sing/e=wha\ever
foo=bar
fox=replaced bar baz
# SECTION
foo=hi' ]
}

@test "REPLACEMENT can refer to capture groups" {
    run updateLine --update-match '\([a-z]\+\)=\(ho\+\) .* \([a-z]\+\)$' --replacement "\2=\1 \3 (&)" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = 'sing/e=wha\ever
foo=bar
hoo=foo baz (foo=hoo bar baz)
# SECTION
foo=hi' ]
}

@test "REPLACEMENT with forward and backslashes" {
    run updateLine --update-match '^foo=h.*$' --replacement '/new\\=\\\\here//' "$FILE"
    [ $status -eq 0 ]
    [ "$output" = 'sing/e=wha\ever
foo=bar
/new\=\\here//
# SECTION
foo=hi' ]
}

@test "empty REPLACEMENT" {
    run updateLine --update-match '^foo=h.*$' --replacement "" "$FILE"

    [ $status -eq 0 ]
    [ "$output" = 'sing/e=wha\ever
foo=bar

# SECTION
foo=hi' ]
}

@test "update with line where REPLACEMENT updates the line to the original content indicates no change" {
    run updateLine --line "foo=new" --update-match '^foo=h.*$' --replacement "foo=hoo bar baz" "$FILE"

    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}
