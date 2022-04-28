#!/usr/bin/env bats

load temp

@test "error when no SED-ARGS passed" {
    run addOrUpdateWithSed -- "$FILE"
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: No SED-ARGS passed." ]
    [ "${lines[1]%% *}" = "Usage:" ]
}

@test "error when combining --in-place and --test-only" {
    run addOrUpdateWithSed --in-place --test-only $SED_UPDATE -- "$FILE"
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: Cannot combine --in-place and --test-only." ]
    [ "${lines[1]%% *}" = "Usage:" ]
}

@test "error when combining --ignore-nonexisting and --create-nonexisting" {
    run addOrUpdateWithSed --ignore-nonexisting --create-nonexisting $SED_UPDATE -- "$FILE"
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: Cannot combine --ignore-nonexisting and --create-nonexisting." ]
    [ "${lines[1]%% *}" = "Usage:" ]
}
