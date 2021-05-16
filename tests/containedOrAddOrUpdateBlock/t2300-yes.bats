#!/usr/bin/env bats

load temp

@test "--yes directly updates without user query" {
    run containedOrAddOrUpdateBlock --yes --in-place --marker test --block-text "$TEXT" "$FILE"
    [ $status -eq 0 ]
    [[ "$output" =~ $(basename "$FILE")\ does\ not\ yet\ contain\ test\.\ Will\ update\ it\ now\. ]]
}
