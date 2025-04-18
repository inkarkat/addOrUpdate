#!/usr/bin/env bats

load temp

@test "message with single file" {
    export MEMOIZEDECISION_CHOICE=y
    run containedOrAddOrUncommentLine --in-place --line disabled "$FILE"
    assert_output -e "does not yet contain 'disabled'. Shall I update it?"
}

@test "message with multiple files" {
    export MEMOIZEDECISION_CHOICE=y
    run containedOrAddOrUncommentLine --in-place --line disabled "$FILE" "$FILE2" "$FILE3"
    assert_output -e "At least one of .* does not yet contain 'disabled'. Shall I update it?"
}

@test "--all message with single file" {
    export MEMOIZEDECISION_CHOICE=y
    run containedOrAddOrUncommentLine --all --in-place --line disabled "$FILE"
    assert_output -e "does not yet contain 'disabled'. Shall I update it?"
}

@test "--all message with multiple files" {
    export MEMOIZEDECISION_CHOICE=y
    run containedOrAddOrUncommentLine --all --in-place --line disabled "$FILE" "$FILE2" "$FILE3"
    assert_output -e "All of .* do not yet contain 'disabled'. Shall I update them?"
}
