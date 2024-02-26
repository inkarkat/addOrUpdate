#!/usr/bin/env bats

load temp

@test "returns 99 and error message and does not modify the file when testing if the file already is up-to-date" {
    cp -f "$RESULT" "$FILE"
    run containedOrUpdateWithPatch --test-only --in-place "$PATCH"
    [ $status -eq 99 ]
    [ "$output" = "existing.txt already contains diff.patch; no update necessary." ]
    cmp -- "$RESULT" "$FILE"
}

@test "returns 0 and message and does not modify the file when testing if the file needs the patch" {
    export MEMOIZEDECISION_CHOICE=y
    run containedOrUpdateWithPatch --test-only --in-place "$PATCH"
    [ $status -eq 0 ]
    [ "$output" = "existing.txt does not contain diff.patch; update required." ]
    cmp -- "$EXISTING" "$FILE"
}

@test "returns 0 and message mentioning the name when testing if the file needs the patch" {
    NAME="My test file"
    export MEMOIZEDECISION_CHOICE=y
    run containedOrUpdateWithPatch --test-only --in-place --name "$NAME" "$PATCH"
    [ $status -eq 0 ]
    [ "$output" = "$NAME does not contain diff.patch; update required." ]
}

@test "returns 0 and no message with an empty one provided when testing if the file needs the patch" {
    export MEMOIZEDECISION_CHOICE=y
    run containedOrUpdateWithPatch --needs-update-message '' --test-only --in-place "$PATCH"
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "returns 0 and a custom passed message when testing if the file needs the patch" {
    MESSAGE='The file needs the new.'
    export MEMOIZEDECISION_CHOICE=y
    run containedOrUpdateWithPatch --needs-update-message "$MESSAGE" --test-only --in-place "$PATCH"
    [ $status -eq 0 ]
    [ "$output" = "$MESSAGE" ]
}
