#!/usr/bin/env bats

load temp

@test "passing just nonexisting files succeeds" {
    UPDATE="foo=new"
    run updateLine --ignore-nonexisting --in-place --update-match "foo=bar" --replacement "$UPDATE" "$NONE" "$NONE2"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ ! -e "$NONE" ]
    [ ! -e "$NONE2" ]
}

@test "passing just nonexisting files succeeds with --all" {
    UPDATE="foo=new"
    run updateLine --all --ignore-nonexisting --in-place --update-match "foo=bar" --replacement "$UPDATE" "$NONE" "$NONE2"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ ! -e "$NONE" ]
    [ ! -e "$NONE2" ]
}
