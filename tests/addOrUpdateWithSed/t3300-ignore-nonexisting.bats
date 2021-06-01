#!/usr/bin/env bats

load temp

@test "passing just nonexisting files succeeds" {
    run addOrUpdateWithSed --ignore-nonexisting --in-place $SED_UPDATE -- "$NONE" "$NONE2"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ ! -e "$NONE" ]
    [ ! -e "$NONE2" ]
}

@test "passing just nonexisting files succeeds with --all" {
    run addOrUpdateWithSed --all --ignore-nonexisting --in-place $SED_UPDATE -- "$NONE" "$NONE2"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ ! -e "$NONE" ]
    [ ! -e "$NONE2" ]
}
