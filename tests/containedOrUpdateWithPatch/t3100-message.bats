#!/usr/bin/env bats

load temp

export MORE="${BATS_TMPDIR}/more.txt"

@test "message with single patch" {
    export MEMOIZEDECISION_CHOICE=y
    run containedOrUpdateWithPatch --in-place "$PATCH"
    [[ "$output" =~ existing\.txt\ does\ not\ yet\ contain\ diff\.patch\.\ Shall\ I\ apply\ it\? ]]
}

@test "message with multiple patches" {
    export MEMOIZEDECISION_CHOICE=y
    run containedOrUpdateWithPatch --in-place "$PATCH" "$ALTERNATIVE_PATCH"
    [[ "$output" =~ existing\.txt\ does\ not\ yet\ contain\ diff\.patch\ and/or\ alternative.patch\.\ Shall\ I\ apply\ them\? ]]
}

@test "message with single patch affecting multiple files" {
    cp -f "$EXISTING" "$OTHER"
    cp -f "$EXISTING" "$MORE"
    export MEMOIZEDECISION_CHOICE=y
    run containedOrUpdateWithPatch --in-place <(renamePatchTarget "$OTHER" "$PATCH"; renamePatchTarget "$MORE" "$PATCH")
    [[ "$output" =~ more\.txt,\ other\.txt\ do\ not\ yet\ contain\ .*\.\ Shall\ I\ apply\ it\? ]]
}

@test "message with multiple patches affecting multiple files" {
    cp -f "$EXISTING" "$OTHER"
    cp -f "$EXISTING" "$MORE"
    export MEMOIZEDECISION_CHOICE=y
    run containedOrUpdateWithPatch --in-place <(renamePatchTarget "$OTHER" "$PATCH") "$REVERTED_PATCH" <(renamePatchTarget "$MORE" "$PATCH")
    [[ "$output" =~ existing\.txt,\ more\.txt,\ other\.txt\ do\ not\ yet\ contain\ .*\ and/or\ reverted\.patch\ and/or\ .*\.\ Shall\ I\ apply\ them\? ]]
}

@test "--all message with single patch affecting multiple files" {
    cp -f "$EXISTING" "$OTHER"
    cp -f "$EXISTING" "$MORE"
    export MEMOIZEDECISION_CHOICE=y
    run containedOrUpdateWithPatch --all --in-place <(renamePatchTarget "$OTHER" "$PATCH"; renamePatchTarget "$MORE" "$PATCH")
    [[ "$output" =~ more\.txt,\ other\.txt\ do\ not\ yet\ contain\ .*\.\ Shall\ I\ apply\ it\? ]]
}
