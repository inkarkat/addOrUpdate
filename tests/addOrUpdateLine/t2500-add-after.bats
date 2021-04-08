#!/usr/bin/env bats

load temp

@test "update with nonexisting line appends after the passed line" {
    UPDATE="foo=new"
    run addOrUpdateLine --line "$UPDATE" --add-after 3 "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "sing/e=wha\\ever
foo=bar
foo=hoo bar baz
$UPDATE
# SECTION
foo=hi" ]
}

@test "update with nonexisting line appends after the passed ADDRESS" {
    UPDATE="foo=new"
    run addOrUpdateLine --line "$UPDATE" --add-after '/^#/' "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "sing/e=wha\\ever
foo=bar
foo=hoo bar baz
# SECTION
$UPDATE
foo=hi" ]
}

@test "update with nonexisting line appends after the first match of ADDRESS only" {
    UPDATE="foo=new"
    run addOrUpdateLine --line "$UPDATE" --add-after '/^foo=/' "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "sing/e=wha\\ever
foo=bar
$UPDATE
foo=hoo bar baz
# SECTION
foo=hi" ]
}

@test "update with existing line after the passed line appends early and ignores the existing later line" {
    run addOrUpdateLine --line "foo=hoo bar baz" --add-after 1 "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "sing/e=wha\ever
foo=hoo bar baz
foo=bar
foo=hoo bar baz
# SECTION
foo=hi" ]
}
@test "update with existing line before the passed line keeps contents and returns 1" {
    run addOrUpdateLine --line "foo=bar" --add-after 3 "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}
