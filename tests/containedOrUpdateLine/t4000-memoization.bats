#!/usr/bin/env bats

load temp

@test "recalls positive choice on yes" {
    init
    REPLACEMENT="&oo"
    export MEMOIZEDECISION_CHOICE=y
    run containedOrUpdateLine --memoize-group containedOrUpdateLine --in-place --update-match "foo=b" --replacement "$REPLACEMENT" "$FILE"
    [ $status -eq 0 ]
    [[ "$output" =~ does\ not\ yet\ contain\ \'$REPLACEMENT\'\.\ Shall\ I\ update\ it\? ]]

    cp -f "$INPUT" "$FILE"  # Restore original file.
    MEMOIZEDECISION_CHOICE=
    run containedOrUpdateLine --memoize-group containedOrUpdateLine --in-place --update-match "foo=b" --replacement "$REPLACEMENT" "$FILE"
    [ $status -eq 0 ]
    [[ "$output" =~ does\ not\ yet\ contain\ \'$REPLACEMENT\'\.\ Will\ update\ it\ now\. ]]
}
