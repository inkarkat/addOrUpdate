#!/usr/bin/env bats

load temp

@test "update with existing line on the passed line updates that line" {
    run updateLine --update-match "foo=b.*" --replacement '&&' --add-before 2 "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "sing/e=wha\ever
foo=barfoo=bar
foo=hoo bar baz
# SECTION
foo=hi" ]
}

@test "update with existing line one after the passed line keeps contents and returns 1" {
    run updateLine --update-match "foo=b.*" --replacement '&&' --add-before 1 "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}
