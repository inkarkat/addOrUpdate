#!/usr/bin/env bats

load temp

@test "returns 99 and error message and does not modify the file when testing if the file already contains the line" {
    run -99 containedOrUpdateAssignment --test-only --in-place --lhs foo --rhs bar "$FILE"
    assert_output "$FILE already contains 'foo=bar'; no update necessary."
    diff -y "$INPUT" "$FILE"
}

@test "returns 0 and message and does not modify the file when testing if the file needs an update" {
    export MEMOIZEDECISION_CHOICE=y
    run -0 containedOrUpdateAssignment --test-only --in-place --lhs foo --rhs new "$FILE"
    assert_output "$FILE does not contain 'foo=new'; update required."
    diff -y "$INPUT" "$FILE"
}

@test "returns 0 and message mentioning the name when testing if the file needs an update" {
    NAME='My test file'
    export MEMOIZEDECISION_CHOICE=y
    run -0 containedOrUpdateAssignment --test-only --in-place --name "$NAME" --lhs foo --rhs new "$FILE"
    assert_output "$NAME does not contain 'foo=new'; update required."
}

@test "returns 0 and no message with an empty one provided when testing if the file needs an update" {
    export MEMOIZEDECISION_CHOICE=y
    run -0 containedOrUpdateAssignment --needs-update-message '' --test-only --in-place --lhs foo --rhs new "$FILE"
    assert_output ''
}

@test "returns 0 and a custom passed message when testing if the file needs an update" {
    MESSAGE='The file needs the new.'
    export MEMOIZEDECISION_CHOICE=y
    run -0 containedOrUpdateAssignment --needs-update-message "$MESSAGE" --test-only --in-place --lhs foo --rhs new "$FILE"
    assert_output "$MESSAGE"
}
