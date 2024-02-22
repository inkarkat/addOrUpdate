#!/usr/bin/env bats

load temp

@test "asks and returns 98 if the update is declined by the user" {
    export MEMOIZEDECISION_CHOICE=n
    run containedOrAddOrUpdateBlock --in-place --marker test --block-text new "$FILE2"
    [ $status -eq 98 ]
    [[ "$output" =~ does\ not\ yet\ contain\ test\.\ Shall\ I\ update\ it\? ]]
}
