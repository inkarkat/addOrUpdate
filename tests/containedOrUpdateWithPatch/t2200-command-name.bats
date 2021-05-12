#!/usr/bin/env bats

load temp

@test "asks with custom command name" {
    NAME="My test file"
    export MEMOIZEDECISION_CHOICE=n
    run containedOrUpdateWithPatch --name "$NAME" --in-place "$PATCH"
    [[ "$output" =~ ${NAME}\ does\ not\ yet\ contain\ diff\.patch\.\ Shall\ I\ apply\ it\? ]]
}
