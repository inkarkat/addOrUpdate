#!/usr/bin/env bats

load temp

@test "patching not-writable existing file returns 4" {
    export MEMOIZEDECISION_CHOICE=y
    chmod -w -- "$FILE"
    [ ! -w "$FILE" ]
    run containedOrUpdateWithPatch --in-place "$PATCH"
    [ $status -eq 4 ]
    [[ "$output" =~ existing\.txt\ does\ not\ yet\ contain\ diff\.patch\.\ Shall\ I\ apply\ it\? ]]
}
