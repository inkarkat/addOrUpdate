#!/usr/bin/env bats

load temp

@test "--yes directly updates without user query" {
    run containedOrUpdateWithPatch --yes --in-place "$PATCH"
    [ $status -eq 0 ]
    [[ "$output" =~ existing\.txt\ does\ not\ yet\ contain\ diff\.patch\.\ Will\ apply\ it\ now\. ]]
}
