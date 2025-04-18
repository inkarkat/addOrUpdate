#!/usr/bin/env bats

load temp

@test "does not modify the file if the file already contains the assignment" {
    run containedOrAddOrUncommentLine --in-place --line 'some data' "$FILE"
    diff -y "$INPUT" "$FILE"
}

@test "returns 99 and error message if the file already contains the assignment" {
    run -99 containedOrAddOrUncommentLine --in-place --line 'some data' "$FILE"
    assert_output "$FILE already contains 'some data'; no update necessary."
}

@test "returns 99 and error message mentioning the name if the file already contains the assignment" {
    NAME='My test file'
    run -99 containedOrAddOrUncommentLine --in-place --name "$NAME" --line 'some data' "$FILE"
    assert_output "$NAME already contains 'some data'; no update necessary."
}

@test "returns 99 and no error message with an empty one passed if the file already contains the assignment" {
    run -99 containedOrAddOrUncommentLine --up-to-date-message '' --in-place --line 'some data' "$FILE"
    assert_output ''
}

@test "returns 99 and a custom passed message if the file already contains the assignment" {
    MESSAGE='The file already has the bar.'
    run -99 containedOrAddOrUncommentLine --up-to-date-message "$MESSAGE" --in-place --line 'some data' "$FILE"
    assert_output "$MESSAGE"
}

@test "returns 4 if none of the passed files exist" {
    run -4 containedOrAddOrUncommentLine --in-place --line 'some data' "$NONE" "$NONE2"
    assert_output ''
}
