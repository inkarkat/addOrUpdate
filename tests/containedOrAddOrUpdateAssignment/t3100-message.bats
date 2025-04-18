#!/usr/bin/env bats

load temp

@test "message with single file" {
    init
    export MEMOIZEDECISION_CHOICE=y
    run containedOrAddOrUpdateAssignment --in-place --lhs foo --rhs new "$FILE"
    assert_output -p "does not yet contain 'foo=new'. Shall I update it?"
}

@test "message with multiple files" {
    init
    export MEMOIZEDECISION_CHOICE=y
    run containedOrAddOrUpdateAssignment --in-place --lhs foo --rhs new "$FILE" "$FILE2" "$FILE3"
    assert_output -e "At least one of .* does not yet contain 'foo=new'\\. Shall I update it\\?"
}

@test "--all message with single file" {
    init
    export MEMOIZEDECISION_CHOICE=y
    run containedOrAddOrUpdateAssignment --all --in-place --lhs foo --rhs new "$FILE"
    assert_output -p "does not yet contain 'foo=new'. Shall I update it?"
}

@test "--all message with multiple files" {
    init
    export MEMOIZEDECISION_CHOICE=y
    run containedOrAddOrUpdateAssignment --all --in-place --lhs foo --rhs new "$FILE" "$FILE2" "$FILE3"
    assert_output -e "All of .* do not yet contain 'foo=new'\\. Shall I update them\\?"
}

