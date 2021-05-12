#!/usr/bin/env bats

load temp

@test "asks, patches, and returns 0 if the patch is accepted by the user" {
    export MEMOIZEDECISION_CHOICE=y
    run containedOrUpdateWithPatch --in-place "$PATCH"
    [ $status -eq 0 ]
    [[ "$output" =~ existing\.txt\ does\ not\ yet\ contain\ diff\.patch\.\ Shall\ I\ apply\ it\? ]]
    cmp "$RESULT" "$FILE"
}

@test "asks about empty patch from null device" {
    export MEMOIZEDECISION_CHOICE=y
    run containedOrUpdateWithPatch --in-place /dev/null
    [ $status -eq 0 ]
    [[ "$output" =~ \?\?\?\ does\ not\ yet\ contain\ null\.\ Shall\ I\ apply\ it\? ]]
}
