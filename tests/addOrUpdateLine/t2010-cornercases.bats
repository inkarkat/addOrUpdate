#!/usr/bin/env bats

load temp

@test "update with existing last line keeps contents and returns 99" {
    run addOrUpdateLine --line "foo=hi" "$FILE"
    [ $status -eq 99 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "in-place update with existing last line keeps contents and returns 99" {
    run addOrUpdateLine --in-place --line "foo=hi" "$FILE"
    [ $status -eq 99 ]
    [ "$output" = "" ]
    cmp "$INPUT" "$FILE"
}

@test "update with existing line on the add-before line keeps contents and returns 99" {
    run addOrUpdateLine --line "foo=hoo bar baz" --add-before 3 "$FILE"
    [ $status -eq 99 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "update with existing line on the add-after line keeps contents and returns 99" {
    run addOrUpdateLine --line "foo=hoo bar baz" --add-after 3 "$FILE"
    [ $status -eq 99 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "in-place update with existing line on the add-before line keeps contents and returns 99" {
    run addOrUpdateLine --in-place --line "foo=hoo bar baz" --add-before 3 "$FILE"
    [ $status -eq 99 ]
    [ "$output" = "" ]
    cmp "$INPUT" "$FILE"
}

@test "in-place update with existing line on the add-after line keeps contents and returns 99" {
    run addOrUpdateLine --in-place --line "foo=hoo bar baz" --add-after 3 "$FILE"
    [ $status -eq 99 ]
    [ "$output" = "" ]
    cmp "$INPUT" "$FILE"
}
