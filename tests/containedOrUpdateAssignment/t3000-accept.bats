#!/usr/bin/env bats

load temp

@test "asks, updates, and returns 0 if the update is accepted by the user" {
    init
    UPDATE="foo=new"
    export MEMOIZEDECISION_CHOICE=y
    run containedOrUpdateAssignment --in-place --lhs foo --rhs new "$FILE"
    [ $status -eq 0 ]
    [[ "$output" =~ does\ not\ yet\ contain\ \'$UPDATE\'\.\ Shall\ I\ update\ it\? ]]
    [ "$(cat "$FILE")" = "sing/e=wha\\ever
$UPDATE
foo=hoo bar baz
# SECTION
fox=hi" ]
}
