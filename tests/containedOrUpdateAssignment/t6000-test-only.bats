#!/usr/bin/env bats

load temp

@test "returns 1 and error message and does not modify the file when testing if the file already contains the line" {
    init
    run containedOrUpdateAssignment --test-only --in-place --lhs foo --rhs bar "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$FILE does not match or already contains 'foo=bar'; no update possible / necessary." ]
    cmp -- "$INPUT" "$FILE"
}

@test "returns 0 and message and does not modify the file when testing if the file needs an update" {
    init
    export MEMOIZEDECISION_CHOICE=y
    run containedOrUpdateAssignment --test-only --in-place --lhs foo --rhs new "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "$FILE does not contain 'foo=new'; update required." ]
    cmp -- "$INPUT" "$FILE"
}

@test "returns 0 and message mentioning the name when testing if the file needs an update" {
    init
    NAME="My test file"
    export MEMOIZEDECISION_CHOICE=y
    run containedOrUpdateAssignment --test-only --in-place --name "$NAME" --lhs foo --rhs new "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "$NAME does not contain 'foo=new'; update required." ]
}

@test "returns 0 and no message with an empty one provided when testing if the file needs an update" {
    init
    export MEMOIZEDECISION_CHOICE=y
    run containedOrUpdateAssignment --needs-update-message '' --test-only --in-place --lhs foo --rhs new "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "returns 0 and a custom passed message when testing if the file needs an update" {
    init
    MESSAGE='The file needs the new.'
    export MEMOIZEDECISION_CHOICE=y
    run containedOrUpdateAssignment --needs-update-message "$MESSAGE" --test-only --in-place --lhs foo --rhs new "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "$MESSAGE" ]
}
