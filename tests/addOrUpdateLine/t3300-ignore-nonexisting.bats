#!/usr/bin/env bats

load temp

@test "passing just nonexisting files succeeds" {
    UPDATE="foo=new"
    run addOrUpdateLine --ignore-nonexisting --in-place --line "$UPDATE" --update-match "foo=bar" "$NONE" "$NONE2"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ ! -e "$NONE" ]
    [ ! -e "$NONE2" ]
}

@test "passing just nonexisting files succeeds with --all" {
    UPDATE="foo=new"
    run addOrUpdateLine --all --ignore-nonexisting --in-place --line "$UPDATE" --update-match "foo=bar" "$NONE" "$NONE2"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ ! -e "$NONE" ]
    [ ! -e "$NONE2" ]
}
