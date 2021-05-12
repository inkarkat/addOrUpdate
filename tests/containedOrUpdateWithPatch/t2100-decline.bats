#!/usr/bin/env bats

load temp

@test "asks and returns 99 if the update is declined by the user" {
    export MEMOIZEDECISION_CHOICE=n
    run containedOrUpdateWithPatch --in-place "$PATCH"
    [ $status -eq 99 ]
    [[ "$output" =~ existing\.txt\ does\ not\ yet\ contain\ diff\.patch\.\ Shall\ I\ apply\ it\? ]]
}
