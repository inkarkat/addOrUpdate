#!/usr/bin/env bats

load temp

@test "does not modify the file if the file already contains the assignment" {
    init
    run containedOrUpdateAssignment --in-place --lhs foo --rhs bar "$FILE"
    cmp -- "$INPUT" "$FILE"
}

@test "returns 1 and error message if the file already contains the assignment" {
    init
    run containedOrUpdateAssignment --in-place --lhs foo --rhs bar "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$FILE already contains 'foo=bar'; no update necessary." ]
}

@test "returns 1 and error message mentioning the name if the file already contains the assignment" {
    init
    NAME="My test file"
    run containedOrUpdateAssignment --in-place --name "$NAME" --lhs foo --rhs bar "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$NAME already contains 'foo=bar'; no update necessary." ]
}

@test "returns 1 and no error message with an empty one passed if the file already contains the assignment" {
    init
    run containedOrUpdateAssignment --up-to-date-message '' --in-place --lhs foo --rhs bar "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "" ]
}

@test "returns 1 and a custom passed message if the file already contains the assignment" {
    init
    MESSAGE='The file already has the bar.'
    run containedOrUpdateAssignment --up-to-date-message "$MESSAGE" --in-place --lhs foo --rhs bar "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$MESSAGE" ]
}

@test "returns 4 if none of the passed files exist" {
    init
    run containedOrUpdateAssignment --in-place --lhs foo --rhs bar "$NONE" "$NONE2"
    [ $status -eq 4 ]
    [ "$output" = "" ]
}
