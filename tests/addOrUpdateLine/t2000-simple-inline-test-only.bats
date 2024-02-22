#!/usr/bin/env bats

load temp

@test "update with nonexisting line appends at the end" {
    UPDATE="foo=new"
    run addOrUpdateLine --line "$UPDATE" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "$(cat "$INPUT")
$UPDATE" ]
}

@test "update with existing line keeps contents and returns 99" {
    run addOrUpdateLine --line "foo=bar" "$FILE"
    [ $status -eq 99 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "update with nonexisting line containing forward and backslash appends at the end" {
    UPDATE='/new\=\here/'
    run addOrUpdateLine --line "$UPDATE" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "$(cat "$INPUT")
$UPDATE" ]
}

@test "update with existing line containing forward and backslash keeps contents and returns 99" {
    run addOrUpdateLine --line 'sing/e=wha\ever' "$FILE"
    [ $status -eq 99 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "in-place update with nonexisting line appends at the end" {
    UPDATE="foo=new"
    run addOrUpdateLine --in-place --line "$UPDATE" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ "$(cat "$FILE")" = "$(cat "$INPUT")
$UPDATE" ]
}

@test "in-place update with existing line keeps contents and returns 99" {
    run addOrUpdateLine --in-place --line "foo=bar" "$FILE"
    [ $status -eq 99 ]
    [ "$output" = "" ]
    cmp "$FILE" "$INPUT"
}

@test "test-only update with nonexisting line succeeds" {
    UPDATE="foo=new"
    run addOrUpdateLine --test-only --line "$UPDATE" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    cmp "$FILE" "$INPUT"
}

@test "test-only update with existing line returns 99" {
    run addOrUpdateLine --test-only --line "foo=bar" "$FILE"
    [ $status -eq 99 ]
    [ "$output" = "" ]
    cmp "$FILE" "$INPUT"
}
