#!/usr/bin/env bats

load temp

@test "asks and returns 98 if the update is declined by the user" {
    init
    export MEMOIZEDECISION_CHOICE=n
    run containedOrUpdateAssignment --in-place --lhs foo --rhs new "$FILE"
    [ $status -eq 98 ]
    [[ "$output" =~ does\ not\ yet\ contain\ \'foo=new\'\.\ Shall\ I\ update\ it\? ]]
}
