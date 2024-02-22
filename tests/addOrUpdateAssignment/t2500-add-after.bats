#!/usr/bin/env bats

load temp

@test "update with nonexisting assignment appends after the passed line" {
    run addOrUpdateAssignment --lhs new --rhs add --add-after 3 "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "sing/e=wha\\ever
foo=bar
foo=hoo bar baz
new=add
# SECTION
fox=hi" ]
}

@test "update with nonexisting assignment appends after the passed ADDRESS" {
    run addOrUpdateAssignment --lhs new --rhs add --add-after '/^#/' "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "sing/e=wha\\ever
foo=bar
foo=hoo bar baz
# SECTION
new=add
fox=hi" ]
}

@test "update with nonexisting assignment appends after the first match of ADDRESS only" {
    run addOrUpdateAssignment --lhs new --rhs add --add-after '/^foo=/' "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "sing/e=wha\\ever
foo=bar
new=add
foo=hoo bar baz
# SECTION
fox=hi" ]
}

@test "update with existing assignment after the passed line keeps contents and returns 99" {
    run addOrUpdateAssignment --lhs foo --rhs bar --add-after 3 "$FILE"
    [ $status -eq 99 ]
    [ "$output" = "$(cat "$INPUT")" ]
}
