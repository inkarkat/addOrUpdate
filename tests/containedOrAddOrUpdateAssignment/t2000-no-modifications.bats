#!/usr/bin/env bats

load temp

@test "does not modify the file if the file already contains the assignment" {
    init
    run containedOrAddOrUpdateAssignment --in-place --lhs foo --rhs bar "$FILE"
    diff -y "$INPUT" "$FILE"
}

@test "returns 99 and error message if the file already contains the assignment" {
    init
    run -99 containedOrAddOrUpdateAssignment --in-place --lhs foo --rhs bar "$FILE"
    assert_output "$FILE already contains 'foo=bar'; no update necessary."
}

@test "returns 99 and error message mentioning the name if the file already contains the assignment" {
    init
    NAME="My test file"
    run -99 containedOrAddOrUpdateAssignment --in-place --name "$NAME" --lhs foo --rhs bar "$FILE"
    assert_output "$NAME already contains 'foo=bar'; no update necessary."
}

@test "returns 99 and no error message with an empty one passed if the file already contains the assignment" {
    init
    run -99 containedOrAddOrUpdateAssignment --up-to-date-message '' --in-place --lhs foo --rhs bar "$FILE"
    assert_output ''
}

@test "returns 99 and a custom passed message if the file already contains the assignment" {
    init
    MESSAGE='The file already has the bar.'
    run -99 containedOrAddOrUpdateAssignment --up-to-date-message "$MESSAGE" --in-place --lhs foo --rhs bar "$FILE"
    assert_output "$MESSAGE"
}

@test "returns 4 if none of the passed files exist" {
    init
    run -4 containedOrAddOrUpdateAssignment --in-place --lhs foo --rhs bar "$NONE" "$NONE2"
    assert_output ''
}
