#!/usr/bin/env bats

load temp

@test "returns 98 and error message and does not modify the file when testing if the file already contains the line" {
    init
    run containedOrAddOrUpdateLine --test-only --in-place --line "foo=bar" "$FILE"
    [ $status -eq 98 ]
    [ "$output" = "$FILE already contains 'foo=bar'; no update necessary." ]
    cmp -- "$INPUT" "$FILE"
}

@test "returns 0 and message and does not modify the file when testing if the file needs an update" {
    init
    export MEMOIZEDECISION_CHOICE=y
    run containedOrAddOrUpdateLine --test-only --in-place --line "foo=new" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "$FILE does not contain 'foo=new'; update required." ]
    cmp -- "$INPUT" "$FILE"
}

@test "returns 0 and message mentioning the name when testing if the file needs an update" {
    init
    NAME="My test file"
    export MEMOIZEDECISION_CHOICE=y
    run containedOrAddOrUpdateLine --test-only --in-place --name "$NAME" --line "foo=new" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "$NAME does not contain 'foo=new'; update required." ]
}

@test "returns 0 and no message with an empty one provided when testing if the file needs an update" {
    init
    export MEMOIZEDECISION_CHOICE=y
    run containedOrAddOrUpdateLine --needs-update-message '' --test-only --in-place --line "foo=new" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "returns 0 and a custom passed message when testing if the file needs an update" {
    init
    MESSAGE='The file needs the new.'
    export MEMOIZEDECISION_CHOICE=y
    run containedOrAddOrUpdateLine --needs-update-message "$MESSAGE" --test-only --in-place --line "foo=new" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "$MESSAGE" ]
}
