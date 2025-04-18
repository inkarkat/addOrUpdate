#!/usr/bin/env bats

load temp

@test "error when no lhs and rhs passed" {
    run -2 addOrAppendAssignment "$FILE"
    assert_line -n 0 'ERROR: Both -l|--lhs ASSIGNEE and -r|--rhs VALUE must be passed.'
    assert_line -n 1 -e '^Usage:'
}

@test "error when no rhs passed" {
    run -2 addOrAppendAssignment --lhs foo "$FILE"
    assert_line -n 0 'ERROR: Both -l|--lhs ASSIGNEE and -r|--rhs VALUE must be passed.'
    assert_line -n 1 -e '^Usage:'
}

@test "error when no lhs passed" {
    run -2 addOrAppendAssignment --rhs bar "$FILE"
    assert_line -n 0 'ERROR: Both -l|--lhs ASSIGNEE and -r|--rhs VALUE must be passed.'
    assert_line -n 1 -e '^Usage:'
}

@test "error when combining --in-place and --test-only" {
    run -2 addOrAppendAssignment --in-place --test-only --lhs foo --rhs new "$FILE"
    assert_line -n 0 'ERROR: Cannot combine --in-place and --test-only.'
    assert_line -n 1 -e '^Usage:'
}

@test "error when combining --ignore-nonexisting and --create-nonexisting" {
    run -2 addOrAppendAssignment --ignore-nonexisting --create-nonexisting --lhs foo --rhs new "$FILE"
    assert_line -n 0 'ERROR: Cannot combine --ignore-nonexisting and --create-nonexisting.'
    assert_line -n 1 -e '^Usage:'
}

@test "error when combining --add-before and --add-after" {
    run -2 addOrAppendAssignment --add-before 4 --add-after 6 --lhs foo --rhs new "$FILE"
    assert_line -n 0 'ERROR: Cannot combine --add-before and --add-after.'
    assert_line -n 1 -e '^Usage:'
}
