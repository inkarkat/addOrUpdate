#!/usr/bin/env bats

load temp

@test "message with replacement" {
    init
    REPLACEMENT="&oo"
    export MEMOIZEDECISION_CHOICE=y
    run containedOrUpdateLine --in-place --update-match "foo=b" --replacement "$REPLACEMENT" "$FILE"
    [ $status -eq 0 ]
    [[ "$output" =~ does\ not\ yet\ contain\ \'$REPLACEMENT\'\.\ Shall\ I\ update\ it\? ]]
    [ "$(cat "$FILE")" = "sing/e=wha\\ever
foo=booar
foo=hoo bar baz
# SECTION
foo=hi" ]
}
