#!/usr/bin/env bats

load temp

@test "error when no lhs and rhs passed" {
    run containedOrUpdateAssignment "$FILE"
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: Both -l|--lhs ASSIGNEE and -r|--rhs VALUE must be passed." ]
    [ "${lines[1]%% *}" = "Usage:" ]
}

@test "error when no rhs passed" {
    run containedOrUpdateAssignment --lhs foo "$FILE"
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: Both -l|--lhs ASSIGNEE and -r|--rhs VALUE must be passed." ]
    [ "${lines[1]%% *}" = "Usage:" ]
}

@test "error when no lhs passed" {
    run containedOrUpdateAssignment --rhs bar "$FILE"
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: Both -l|--lhs ASSIGNEE and -r|--rhs VALUE must be passed." ]
    [ "${lines[1]%% *}" = "Usage:" ]
}

@test "error when combining --create-nonexisting" {
    run containedOrUpdateAssignment --create-nonexisting --lhs foo --rhs new "$FILE"
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: Cannot use --create-nonexisting when appending is not allowed." ]
    [ "${lines[1]%% *}" = "Usage:" ]
}
