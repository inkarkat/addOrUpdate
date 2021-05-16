#!/usr/bin/env bats

load temp

@test "override memoizeDecision with printPositiveDecision" {
    init
    UPDATE="foo=new"
    export MEMOIZEDECISION=printPositiveDecision
    run containedOrAddOrUpdateLine --in-place --line "$UPDATE" "$FILE"
    [[ "$output" =~ $(basename "$FILE")\ does\ not\ yet\ contain\ \'foo=new\'\.\ Will\ update\ it\ now\. ]]
}
