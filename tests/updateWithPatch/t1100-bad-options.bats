#!/usr/bin/env bats

load temp

@test "error when no PATCH passed" {
    run updateWithPatch
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: No PATCH passed." ]
    [ "${lines[1]%% *}" = "Usage:" ]
}

@test "error when combining --in-place and --test-only" {
    run updateWithPatch --in-place --test-only "$PATCH"
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: Cannot combine --in-place and --test-only." ]
    [ "${lines[1]%% *}" = "Usage:" ]
}

@test "error when combining --first and --all" {
    run updateWithPatch --first --all "$PATCH"
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: Cannot combine --first and --all." ]
    [ "${lines[1]%% *}" = "Usage:" ]
}
