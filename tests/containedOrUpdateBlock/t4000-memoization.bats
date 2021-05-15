#!/usr/bin/env bats

load temp

@test "recalls positive choice on yes" {
    export MEMOIZEDECISION_CHOICE=y
    run containedOrUpdateBlock --memoize-group containedOrUpdateBlock --in-place --marker test --block-text "$TEXT" "$FILE2"
    [ $status -eq 0 ]
    [[ "$output" =~ $(basename "$FILE2")\ does\ not\ yet\ contain\ test\.\ Shall\ I\ update\ it\? ]]

    cp -f "$EXISTING" "$FILE2"  # Restore original file.
    MEMOIZEDECISION_CHOICE=
    run containedOrUpdateBlock --memoize-group containedOrUpdateBlock --in-place --marker test --block-text "$TEXT" "$FILE2"
    [ $status -eq 0 ]
    [[ "$output" =~ $(basename "$FILE2")\ does\ not\ yet\ contain\ test\.\ Will\ update\ it\ now\. ]]
}
