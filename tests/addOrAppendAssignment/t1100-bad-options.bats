#!/usr/bin/env bats

load temp

@test "error when no lhs and rhs passed" {
    run addOrAppendAssignment "$FILE"
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: Both -l|--lhs ASSIGNEE and -r|--rhs VALUE must be passed." ]
    [ "${lines[1]%% *}" = "Usage:" ]
}

@test "error when no rhs passed" {
    run addOrAppendAssignment --lhs foo "$FILE"
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: Both -l|--lhs ASSIGNEE and -r|--rhs VALUE must be passed." ]
    [ "${lines[1]%% *}" = "Usage:" ]
}

@test "error when no lhs passed" {
    run addOrAppendAssignment --rhs bar "$FILE"
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: Both -l|--lhs ASSIGNEE and -r|--rhs VALUE must be passed." ]
    [ "${lines[1]%% *}" = "Usage:" ]
}

@test "error when combining --in-place and --test-only" {
    run addOrAppendAssignment --in-place --test-only --lhs foo --rhs new "$FILE"
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: Cannot combine --in-place and --test-only." ]
    [ "${lines[1]%% *}" = "Usage:" ]
}

@test "error when combining --ignore-nonexisting and --create-nonexisting" {
    run addOrAppendAssignment --ignore-nonexisting --create-nonexisting --lhs foo --rhs new "$FILE"
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: Cannot combine --ignore-nonexisting and --create-nonexisting." ]
    [ "${lines[1]%% *}" = "Usage:" ]
}

@test "error when combining --add-before and --add-after" {
    run addOrAppendAssignment --add-before 4 --add-after 6 --lhs foo --rhs new "$FILE"
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: Cannot combine --add-before and --add-after." ]
    [ "${lines[1]%% *}" = "Usage:" ]
}
