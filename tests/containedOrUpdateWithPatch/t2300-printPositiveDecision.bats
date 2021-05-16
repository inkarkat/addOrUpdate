#!/usr/bin/env bats

load temp

@test "override memoizeDecision with printPositiveDecision" {
    export MEMOIZEDECISION=printPositiveDecision
    run containedOrUpdateWithPatch --in-place "$PATCH"
    [ $status -eq 0 ]
    [[ "$output" =~ existing\.txt\ does\ not\ yet\ contain\ diff\.patch\.\ Will\ apply\ it\ now\. ]]
}
