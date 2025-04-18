#!/usr/bin/env bats

load temp

@test "returns 99 and error message and does not modify the file when testing if the file already contains the block" {
    run -99 containedOrAddOrUpdateBlock --test-only --in-place --marker subsequent --block-text "Single line" "$FILE2"
    assert_output "$FILE2 already contains subsequent; no update necessary."
    diff -y "$EXISTING" "$FILE2"
}

@test "returns 0 and message and does not modify the file when testing if the file needs an update" {
    export MEMOIZEDECISION_CHOICE=y
    run -0 containedOrAddOrUpdateBlock --test-only --in-place --marker test --block-text "$TEXT" "$FILE"
    assert_output "$FILE does not contain test; update required."
    diff -y "$FRESH" "$FILE"
}

@test "returns 0 and message mentioning the name when testing if the file needs an update" {
    NAME="My test file"
    export MEMOIZEDECISION_CHOICE=y
    run -0 containedOrAddOrUpdateBlock --test-only --in-place --name "$NAME" --marker test --block-text "$TEXT" "$FILE"
    assert_output "$NAME does not contain test; update required."
}

@test "returns 0 and no message with an empty one provided when testing if the file needs an update" {
    export MEMOIZEDECISION_CHOICE=y
    run -0 containedOrAddOrUpdateBlock --needs-update-message '' --test-only --in-place --marker test --block-text "$TEXT" "$FILE"
    assert_output ''
}

@test "returns 0 and a custom passed message when testing if the file needs an update" {
    MESSAGE='The file needs the new block.'
    export MEMOIZEDECISION_CHOICE=y
    run -0 containedOrAddOrUpdateBlock --needs-update-message "$MESSAGE" --test-only --in-place --marker test --block-text "$TEXT" "$FILE"
    assert_output "$MESSAGE"
}
