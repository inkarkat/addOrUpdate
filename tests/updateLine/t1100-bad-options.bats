#!/usr/bin/env bats

load temp

@test "error when no PATTERN passed" {
    run updateLine --replacement new "$FILE"
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: No --update-match PATTERN passed." ]
    [ "${lines[1]%% *}" = "Usage:" ]
}

@test "error when no REPLACEMENT passed" {
    run updateLine --update-match old "$FILE"
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: No --replacement REPLACEMENT passed." ]
    [ "${lines[1]%% *}" = "Usage:" ]
}

@test "error when combining --in-place and --test-only" {
    run updateLine --in-place --test-only --update-match old --replacement new "$FILE"
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: Cannot combine --in-place and --test-only." ]
    [ "${lines[1]%% *}" = "Usage:" ]
}

@test "error when combining --ignore-nonexisting and --create-nonexisting" {
    run updateLine --ignore-nonexisting --create-nonexisting --update-match old --replacement new "$FILE"
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: Cannot combine --ignore-nonexisting and --create-nonexisting." ]
    [ "${lines[1]%% *}" = "Usage:" ]
}

@test "error when combining --add-before and --add-after" {
    run updateLine --add-before 4 --add-after 6 --update-match old --replacement new "$FILE"
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: Cannot combine --add-before and --add-after." ]
    [ "${lines[1]%% *}" = "Usage:" ]
}

@test "error on --create-nonexisting" {
    run updateLine --create-nonexisting --update-match old --replacement new "$FILE"
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: Cannot use --create-nonexisting when appending is not allowed." ]
    [ "${lines[1]%% *}" = "Usage:" ]
}

@test "error when no --update-match is passed" {
    run updateLine --replacement new "$FILE"
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: No --update-match PATTERN passed." ]
    [ "${lines[1]%% *}" = "Usage:" ]
}

@test "error when no --replacement is passed" {
    run updateLine --update-match old "$FILE"
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: No --replacement REPLACEMENT passed." ]
    [ "${lines[1]%% *}" = "Usage:" ]
}
