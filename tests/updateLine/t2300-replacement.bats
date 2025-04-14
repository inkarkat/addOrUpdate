#!/usr/bin/env bats

load temp

@test "update with pattern matching full line uses LINE" {
    run updateLine --update-match '^foo=h.*$' --line "ox=replaced" "$FILE"

    [ $status -eq 0 ]
    [ "$output" = 'sing/e=wha\ever
foo=bar
ox=replaced
# SECTION
foo=hi' ]
}

@test "update with pattern matching partial line uses LINE just for match" {
    run updateLine --update-match 'oo=h[a-z]\+' --line "ox=replaced" "$FILE"
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

@test "empty LINE is not supported" {
    run updateLine --update-match '^foo=h.*$' --line '' "$FILE"

    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: No --line LINE or --replacement REPLACEMENT passed.' ]
}

@test "empty REPLACEMENT" {
    run updateLine --update-match '^foo=h.*$' --replacement '' "$FILE"

    [ $status -eq 0 ]
    [ "$output" = 'sing/e=wha\ever
foo=bar

# SECTION
foo=hi' ]
}

@test "update with line where REPLACEMENT updates the line to the original content indicates no change" {
    run updateLine --line "foo=new" --update-match '^foo=h.*$' --replacement "foo=hoo bar baz" "$FILE"

    [ $status -eq 99 ]
    [ "$output" = "$(cat "$INPUT")" ]
}
