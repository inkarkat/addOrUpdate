#!/usr/bin/env bats

load temp

@test "test-only update with nonexisting file does not create it" {
    run addOrUpdateWithSed --test-only --create-nonexisting $SED_UPDATE -- "$NONE"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ ! -e "$NONE" ]
}

@test "test-only update with all nonexisting files creates none" {
    run addOrUpdateWithSed --test-only --create-nonexisting $SED_UPDATE -- "$NONE" "$NONE2"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ ! -e "$NONE" ]
    [ ! -e "$NONE2" ]
}

@test "test-only update with nonexisting first file does not create it" {
    run addOrUpdateWithSed --test-only --create-nonexisting $SED_UPDATE -- "$NONE" "$FILE" "$NONE2" "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ ! -e "$NONE" ]
    [ ! -e "$NONE2" ]
}

@test "test-only update with nonexisting files and --all creates none" {
    run addOrUpdateWithSed --test-only --create-nonexisting --all $SED_UPDATE -- "$NONE" "$FILE" "$NONE2" "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ ! -e "$NONE" ]
    [ ! -e "$NONE2" ]
}
