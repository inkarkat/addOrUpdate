#!/usr/bin/env bats

load temp

@test "returns 99 and no output if implicit stdin already contains the line" {
    INPUT="SOME line
foo=bar
more"
    export MEMOIZEDECISION_CHOICE=n
    run -99 containedOrAddOrUpdateAssignment --lhs foo --rhs bar <<<"$INPUT"
    assert_output -e " already contains 'foo=bar'; no update necessary\\.\$"
}

@test "returns 99 and no output if stdin as - already contains the line" {
    INPUT="Some line
foo=bar
more"
    export MEMOIZEDECISION_CHOICE=n
    run -99 containedOrAddOrUpdateAssignment --lhs foo --rhs bar - <<<"$INPUT"
    assert_output -e " already contains 'foo=bar'; no update necessary\\.\$"
}

@test "asks and returns 98 and no output if the update is declined by the user" {
    INPUT="foo=bar"
    UPDATE="foo=new"
    export MEMOIZEDECISION_CHOICE=n
    run -98 containedOrAddOrUpdateAssignment --lhs foo --rhs new - <<<"$INPUT"
    assert_output -p "does not yet contain '$UPDATE'. Shall I update it?"
}

