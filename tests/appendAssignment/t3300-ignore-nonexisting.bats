#!/usr/bin/env bats

load temp

@test "passing just nonexisting files succeeds" {
    run appendAssignment --ignore-nonexisting --in-place --lhs foo --rhs new "$NONE" "$NONE2"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ ! -e "$NONE" ]
    [ ! -e "$NONE2" ]
}

@test "passing just nonexisting files succeeds with --all" {
    run appendAssignment --all --ignore-nonexisting --in-place --lhs foo --rhs new "$NONE" "$NONE2"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ ! -e "$NONE" ]
    [ ! -e "$NONE2" ]
}
