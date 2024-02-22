#!/usr/bin/env bats

load temp

@test "returns 99 and error message and does not modify the file when testing if the file already contains the block" {
    run containedOrAddOrUpdateBlock --test-only --in-place --marker subsequent --block-text "Single line" "$FILE2"
    [ $status -eq 99 ]
    [ "$output" = "$FILE2 already contains subsequent; no update necessary." ]
    cmp -- "$EXISTING" "$FILE2"
}

@test "returns 0 and message and does not modify the file when testing if the file needs an update" {
    export MEMOIZEDECISION_CHOICE=y
    run containedOrAddOrUpdateBlock --test-only --in-place --marker test --block-text "$TEXT" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "$FILE does not contain test; update required." ]
    cmp -- "$FRESH" "$FILE"
}

@test "returns 0 and message mentioning the name when testing if the file needs an update" {
    NAME="My test file"
    export MEMOIZEDECISION_CHOICE=y
    run containedOrAddOrUpdateBlock --test-only --in-place --name "$NAME" --marker test --block-text "$TEXT" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "$NAME does not contain test; update required." ]
}

@test "returns 0 and no message with an empty one provided when testing if the file needs an update" {
    export MEMOIZEDECISION_CHOICE=y
    run containedOrAddOrUpdateBlock --needs-update-message '' --test-only --in-place --marker test --block-text "$TEXT" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "returns 0 and a custom passed message when testing if the file needs an update" {
    MESSAGE='The file needs the new block.'
    export MEMOIZEDECISION_CHOICE=y
    run containedOrAddOrUpdateBlock --needs-update-message "$MESSAGE" --test-only --in-place --marker test --block-text "$TEXT" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "$MESSAGE" ]
}
