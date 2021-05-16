#!/usr/bin/env bats

load temp

@test "override memoizeDecision with printPositiveDecision" {
    export MEMOIZEDECISION=printPositiveDecision
    run containedOrAddOrUpdateBlock --in-place --marker test --block-text "$TEXT" "$FILE"
    [ $status -eq 0 ]
    [[ "$output" =~ $(basename "$FILE")\ does\ not\ yet\ contain\ test\.\ Will\ update\ it\ now\. ]]
}
