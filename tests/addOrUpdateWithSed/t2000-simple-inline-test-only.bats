#!/usr/bin/env bats

load temp

@test "update first line succeeds" {
    UPDATE="foo=new"
    run addOrUpdateWithSed $SED_UPDATE -- "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "updated
foo=bar
foo=hoo bar baz
# SECTION
foo=hi" ]
}

@test "update with error returns 1" {
    run addOrUpdateWithSed $SED_ERROR -- "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "update with no modification returns 99" {
    run addOrUpdateWithSed $SED_NO_MOD -- "$FILE"
    [ $status -eq 99 ]
    [ "$output" = "$(cat "$INPUT")" ]
}

@test "in-place update of first line succeeds" {
    UPDATE="foo=new"
    run addOrUpdateWithSed --in-place $SED_UPDATE -- "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ "$(cat "$FILE")" = "updated
foo=bar
foo=hoo bar baz
# SECTION
foo=hi" ]
}

@test "in-place update with error returns 1" {
    run addOrUpdateWithSed --in-place $SED_ERROR -- "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "" ]
    cmp "$FILE" "$INPUT"
}

@test "in-place update with no modification returns 99" {
    run addOrUpdateWithSed --in-place $SED_NO_MOD -- "$FILE"
    [ $status -eq 99 ]
    [ "$output" = "" ]
    cmp "$FILE" "$INPUT"
}

@test "test-only update with update of first line succeeds" {
    run addOrUpdateWithSed --test-only $SED_UPDATE -- "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    cmp "$FILE" "$INPUT"
}

@test "test-only update with error returns 1" {
    run addOrUpdateWithSed --test-only $SED_ERROR -- "$FILE"
    [ $status -eq 1 ]
    [ "$output" = "" ]
    cmp "$FILE" "$INPUT"
}

@test "test-only update with no modification returns 99" {
    run addOrUpdateWithSed --test-only $SED_NO_MOD -- "$FILE"
    [ $status -eq 99 ]
    [ "$output" = "" ]
    cmp "$FILE" "$INPUT"
}
