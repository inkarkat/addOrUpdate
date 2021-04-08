#!/usr/bin/env bats

load temp

@test "update with nonexisting line inserts on the passed line" {
    UPDATE="foo=new"
    run addOrUpdateLine --line "$UPDATE" --add-before 4 "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "sing/e=wha\\ever
foo=bar
foo=hoo bar baz
$UPDATE
# SECTION
foo=hi" ]
}

@test "update with nonexisting line inserts on the passed ADDRESS" {
    UPDATE="foo=new"
    run addOrUpdateLine --line "$UPDATE" --add-before '/^#/' "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "sing/e=wha\\ever
foo=bar
foo=hoo bar baz
$UPDATE
# SECTION
foo=hi" ]
}

@test "update with nonexisting line inserts on the first match of ADDRESS only" {
    UPDATE="foo=new"
    run addOrUpdateLine --line "$UPDATE" --add-before '/^foo=/' "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "sing/e=wha\\ever
$UPDATE
foo=bar
foo=hoo bar baz
# SECTION
foo=hi" ]
}

@test "update with existing line on the passed line keeps contents and returns 1" {
    run addOrUpdateLine --line "foo=bar" --add-before 2 "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "update with existing line one after the passed line appends early and ignores the existing later line" {
    run addOrUpdateLine --line "foo=bar" --add-before 1 "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "foo=bar
sing/e=wha\\ever
foo=bar
foo=hoo bar baz
# SECTION
foo=hi" ]
}
