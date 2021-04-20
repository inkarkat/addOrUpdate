#!/usr/bin/env bats

load temp

@test "passing just nonexisting files succeeds" {
    run updateBlock --ignore-nonexisting --in-place --marker test --block-text "$TEXT" "$NONE" "$NONE2"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ ! -e "$NONE" ]
    [ ! -e "$NONE2" ]
}

@test "passing just nonexisting files succeeds with --all" {
    run updateBlock --all --ignore-nonexisting --in-place --marker test --block-text "$TEXT" "$NONE" "$NONE2"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ ! -e "$NONE" ]
    [ ! -e "$NONE2" ]
}
