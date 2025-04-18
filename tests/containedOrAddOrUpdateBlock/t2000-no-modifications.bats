#!/usr/bin/env bats

load temp

@test "does not modify the file if the file already contains the line" {
    run containedOrAddOrUpdateBlock --in-place --marker subsequent --block-text "Single line" "$FILE2"
    diff -y "$EXISTING" "$FILE2"
}

@test "returns 99 and error message if the file already contains the block" {
    run -99 containedOrAddOrUpdateBlock --in-place --marker subsequent --block-text "Single line" "$FILE2"
    assert_output "$FILE2 already contains subsequent; no update necessary."
}

@test "returns 99 and error message mentioning the name if the file already contains the block" {
    NAME='My test file'
    run -99 containedOrAddOrUpdateBlock --in-place --name "$NAME" --marker subsequent --block-text "Single line" "$FILE2"
    assert_output "$NAME already contains subsequent; no update necessary."
}

@test "returns 99 and no error message with an empty one passed if the file already contains the block" {
    run -99 containedOrAddOrUpdateBlock --up-to-date-message '' --in-place --marker subsequent --block-text "Single line" "$FILE2"
    assert_output ''
}

@test "returns 99 and a custom passed message if the file already contains the block" {
    MESSAGE='The file already has the bar.'
    run -99 containedOrAddOrUpdateBlock --up-to-date-message "$MESSAGE" --in-place --marker subsequent --block-text "Single line" "$FILE2"
    assert_output "$MESSAGE"
}

@test "returns 4 if none of the passed files exist" {
    run -4 containedOrAddOrUpdateBlock --in-place --marker test --block-text new "$NONE" "$NONE2"
    assert_output ''
}
