#!/usr/bin/env bats

load temp

@test "error when no lhs and rhs passed" {
    run -2 containedOrUpdateAssignment "$FILE"
    assert_line -n 0 'ERROR: Both -l|--lhs ASSIGNEE and -r|--rhs VALUE must be passed.'
    assert_line -n 1 -e '^Usage:'
}

@test "error when no rhs passed" {
    run -2 containedOrUpdateAssignment --lhs foo "$FILE"
    assert_line -n 0 'ERROR: Both -l|--lhs ASSIGNEE and -r|--rhs VALUE must be passed.'
    assert_line -n 1 -e '^Usage:'
}

@test "error when no lhs passed" {
    run -2 containedOrUpdateAssignment --rhs bar "$FILE"
    assert_line -n 0 'ERROR: Both -l|--lhs ASSIGNEE and -r|--rhs VALUE must be passed.'
    assert_line -n 1 -e '^Usage:'
}

@test "error when combining --create-nonexisting" {
    run -2 containedOrUpdateAssignment --create-nonexisting --lhs foo --rhs new "$FILE"
    assert_line -n 0 'ERROR: Cannot use --create-nonexisting when appending is not allowed.'
    assert_line -n 1 -e '^Usage:'
}
