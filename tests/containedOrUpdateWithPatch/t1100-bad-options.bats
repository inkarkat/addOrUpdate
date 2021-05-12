#!/usr/bin/env bats

load temp

@test "error when no PATCH passed" {
    run containedOrUpdateWithPatch
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: No PATCH passed." ]
    [ "${lines[1]%% *}" = "Usage:" ]
}

@test "error when combining --first and --all" {
    run containedOrUpdateWithPatch --first --all "$PATCH"
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: Cannot combine --first and --all." ]
    [ "${lines[1]%% *}" = "Usage:" ]
}
