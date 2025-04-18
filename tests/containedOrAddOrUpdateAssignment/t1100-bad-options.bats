#!/usr/bin/env bats

load temp

@test "error when no lhs and rhs passed" {
    run -2 containedOrAddOrUpdateAssignment "$FILE"
    assert_line -n 0 'ERROR: Both -l|--lhs ASSIGNEE and -r|--rhs VALUE must be passed.'
    assert_line -n 1 -e '^Usage:'
}

@test "error when no rhs passed" {
    run -2 containedOrAddOrUpdateAssignment --lhs foo "$FILE"
    assert_line -n 0 'ERROR: Both -l|--lhs ASSIGNEE and -r|--rhs VALUE must be passed.'
    assert_line -n 1 -e '^Usage:'
}

@test "error when no lhs passed" {
    run -2 containedOrAddOrUpdateAssignment --rhs bar "$FILE"
    assert_line -n 0 'ERROR: Both -l|--lhs ASSIGNEE and -r|--rhs VALUE must be passed.'
    assert_line -n 1 -e '^Usage:'
}

@test "error when combining --ignore-nonexisting and --create-nonexisting" {
    run -2 containedOrAddOrUpdateAssignment --ignore-nonexisting --create-nonexisting --lhs foo --rhs new "$FILE"
    assert_line -n 0 'ERROR: Cannot combine --ignore-nonexisting and --create-nonexisting.'
    assert_line -n 1 -e '^Usage:'
}
