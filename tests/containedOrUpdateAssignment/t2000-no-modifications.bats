#!/usr/bin/env bats

load temp

@test "does not modify the file if the file already contains the assignment" {
    run containedOrUpdateAssignment --in-place --lhs foo --rhs bar "$FILE"
    diff -y "$INPUT" "$FILE"
}

@test "returns 1 and error message if the file does not have such an assignment" {
    run -1 containedOrUpdateAssignment --in-place --lhs "nowhereToBeFound" --rhs bar "$FILE"
    assert_output "$FILE does not match; no update possible."
}

@test "returns 99 and error message if the file already contains the assignment" {
    run -99 containedOrUpdateAssignment --in-place --lhs foo --rhs bar "$FILE"
    assert_output "$FILE already contains 'foo=bar'; no update necessary."
}

@test "returns 99 and error message mentioning the name if the file already contains the assignment" {
    NAME='My test file'
    run -99 containedOrUpdateAssignment --in-place --name "$NAME" --lhs foo --rhs bar "$FILE"
    assert_output "$NAME already contains 'foo=bar'; no update necessary."
}

@test "returns 99 and no error message with an empty one passed if the file already contains the assignment" {
    run -99 containedOrUpdateAssignment --up-to-date-message '' --in-place --lhs foo --rhs bar "$FILE"
    assert_output ''
}

@test "returns 99 and a custom passed message if the file already contains the assignment" {
    MESSAGE='The file already has the bar.'
    run -99 containedOrUpdateAssignment --up-to-date-message "$MESSAGE" --in-place --lhs foo --rhs bar "$FILE"
    assert_output "$MESSAGE"
}

@test "returns 4 if none of the passed files exist" {
    run -4 containedOrUpdateAssignment --in-place --lhs foo --rhs bar "$NONE" "$NONE2"
    assert_output ''
}
