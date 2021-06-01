#!/usr/bin/env bats

load temp

@test "processing standard input with creation of nonexisting works" {
    CONTENTS="# useless
stuff"
    output="$(echo "$CONTENTS" | addOrUpdateWithSed --create-nonexisting $SED_UPDATE)"
    [ "$output" = "updated
stuff" ]
}

@test "update with nonexisting first file creates and inserts there" {
    run addOrUpdateWithSed --create-nonexisting --in-place $SED_UPDATE -- "$NONE" "$FILE" "$NONE2" "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ -e "$NONE" ]
    [ "$(cat "$NONE")" = "updated" ]
    cmp "$FILE" "$INPUT"
    cmp "$FILE2" "$MORE2"
    [ ! -e "$NONE2" ]
}

@test "update with all nonexisting files creates and inserts in the first one" {
    run addOrUpdateWithSed --create-nonexisting --in-place $SED_UPDATE -- "$NONE" "$NONE2"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ -e "$NONE" ]
    [ "$(cat "$NONE")" = "updated" ]
    [ ! -e "$NONE2" ]
}

@test "update with nonexisting files and --all creates and inserts in each" {
    run addOrUpdateWithSed --create-nonexisting --all --in-place $SED_UPDATE -- "$NONE" "$FILE" "$NONE2" "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ -e "$NONE" ]
    [ -e "$NONE2" ]
    [ "$(cat "$NONE")" = "updated" ]
    [ "$(cat "$NONE2")" = "updated" ]
    [ "$(cat "$FILE")" = "updated
foo=bar
foo=hoo bar baz
# SECTION
foo=hi" ]
    [ "$(cat "$FILE2")" = "updated
quux=initial
foo=moo bar baz" ]
}

@test "update with all nonexisting files and --all creates and inserts in each" {
    run addOrUpdateWithSed --create-nonexisting --all --in-place $SED_UPDATE -- "$NONE" "$NONE2"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ -e "$NONE" ]
    [ -e "$NONE2" ]
    [ "$(cat "$NONE")" = "updated" ]
    [ "$(cat "$NONE2")" = "updated" ]
}
