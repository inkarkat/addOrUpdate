#!/usr/bin/env bats

load temp

@test "asks again on confirm each" {
    export MEMOIZEDECISION_CHOICE=c
    run containedOrUpdateWithPatch --memoize-group containedOrUpdateWithPatch --in-place "$PATCH"
    [ $status -eq 0 ]
    [[ "$output" =~ existing\.txt\ does\ not\ yet\ contain\ diff\.patch\.\ Shall\ I\ apply\ it\? ]]

    cp -f "$EXISTING" "$FILE"	# Restore original file.
    run containedOrUpdateWithPatch --memoize-group containedOrUpdateWithPatch --in-place "$PATCH"
    [ $status -eq 0 ]
    [[ "$output" =~ existing\.txt\ does\ not\ yet\ contain\ diff\.patch\.\ Shall\ I\ apply\ it\? ]]
}

@test "recalls positive choice on yes" {
    export MEMOIZEDECISION_CHOICE=y
    run containedOrUpdateWithPatch --memoize-group containedOrUpdateWithPatch --in-place "$PATCH"
    [ $status -eq 0 ]
    [[ "$output" =~ existing\.txt\ does\ not\ yet\ contain\ diff\.patch\.\ Shall\ I\ apply\ it\? ]]

    cp -f "$EXISTING" "$FILE"	# Restore original file.
    MEMOIZEDECISION_CHOICE=
    run containedOrUpdateWithPatch --memoize-group containedOrUpdateWithPatch --in-place "$PATCH"
    [ $status -eq 0 ]
    [[ "$output" =~ existing\.txt\ does\ not\ yet\ contain\ diff\.patch\.\ Will\ apply\ it\ now\. ]]
}

@test "does not recall another file on yes" {
    cp -f "$EXISTING" "$OTHER"
    export MEMOIZEDECISION_CHOICE=y
    run containedOrUpdateWithPatch --memoize-group containedOrUpdateWithPatch --in-place "$PATCH"
    [ $status -eq 0 ]
    [[ "$output" =~ existing\.txt\ does\ not\ yet\ contain\ diff\.patch\.\ Shall\ I\ apply\ it\? ]]

    MEMOIZEDECISION_CHOICE=y
    run containedOrUpdateWithPatch --memoize-group containedOrUpdateWithPatch --in-place <(renamePatchTarget "$OTHER" "$PATCH")
    [ $status -eq 0 ]
    [[ "$output" =~ other\.txt\ does\ not\ yet\ contain\ .*\.\ Shall\ I\ apply\ it\? ]]
}

@test "recalls another file on any" {
    cp -f "$EXISTING" "$OTHER"
    export MEMOIZEDECISION_CHOICE=a
    run containedOrUpdateWithPatch --memoize-group containedOrUpdateWithPatch --in-place "$PATCH"
    [ $status -eq 0 ]
    [[ "$output" =~ existing\.txt\ does\ not\ yet\ contain\ diff\.patch\.\ Shall\ I\ apply\ it\? ]]

    MEMOIZEDECISION_CHOICE=n
    run containedOrUpdateWithPatch --memoize-group containedOrUpdateWithPatch --in-place <(renamePatchTarget "$OTHER" "$PATCH")
    [ $status -eq 0 ]
    [[ "$output" =~ other\.txt\ does\ not\ yet\ contain\ .*\.\ Will\ apply\ it\ now\. ]]
}
