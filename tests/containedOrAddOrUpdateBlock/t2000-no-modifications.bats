#!/usr/bin/env bats

load temp

@test "does not modify the file if the file already contains the line" {
    run containedOrAddOrUpdateBlock --in-place --marker subsequent --block-text "Single line" "$FILE2"
    cmp -- "$EXISTING" "$FILE2"
}

@test "returns 98 and error message if the file already contains the block" {
    run containedOrAddOrUpdateBlock --in-place --marker subsequent --block-text "Single line" "$FILE2"
    [ $status -eq 98 ]
    [ "$output" = "$FILE2 already contains subsequent; no update necessary." ]
}

@test "returns 98 and error message mentioning the name if the file already contains the block" {
    NAME="My test file"
    run containedOrAddOrUpdateBlock --in-place --name "$NAME" --marker subsequent --block-text "Single line" "$FILE2"
    [ $status -eq 98 ]
    [ "$output" = "$NAME already contains subsequent; no update necessary." ]
}

@test "returns 98 and no error message with an empty one passed if the file already contains the block" {
    run containedOrAddOrUpdateBlock --up-to-date-message '' --in-place --marker subsequent --block-text "Single line" "$FILE2"
    [ $status -eq 98 ]
    [ "$output" = "" ]
}

@test "returns 98 and a custom passed message if the file already contains the block" {
    MESSAGE='The file already has the bar.'
    run containedOrAddOrUpdateBlock --up-to-date-message "$MESSAGE" --in-place --marker subsequent --block-text "Single line" "$FILE2"
    [ $status -eq 98 ]
    [ "$output" = "$MESSAGE" ]
}

@test "returns 4 if none of the passed files exist" {
    run containedOrAddOrUpdateBlock --in-place --marker test --block-text new "$NONE" "$NONE2"
    [ $status -eq 4 ]
    [ "$output" = "" ]
}
