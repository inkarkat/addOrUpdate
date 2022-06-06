#!/usr/bin/env bats

load temp

@test "processing standard input with creation of nonexisting works" {
    CONTENTS="# useless"
    output="$(echo "$CONTENTS" | addOrAppendAssignment --create-nonexisting --lhs foo --rhs new)"
    [ "$output" = "$CONTENTS
foo=\"new\"" ]
}

@test "update with nonexisting first file creates and appends there" {
    run addOrAppendAssignment --create-nonexisting --in-place --lhs foo --rhs new "$NONE" "$FILE" "$NONE2" "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ -e "$NONE" ]
    [ "$(cat "$NONE")" = 'foo="new"' ]
    cmp "$FILE" "$INPUT"
    cmp "$FILE2" "$MORE2"
    [ ! -e "$NONE2" ]
}

@test "update with all nonexisting files creates and appends to the first one" {
    run addOrAppendAssignment --create-nonexisting --in-place --lhs foo --rhs new "$NONE" "$NONE2"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ -e "$NONE" ]
    [ "$(cat "$NONE")" = 'foo="new"' ]
    [ ! -e "$NONE2" ]
}

@test "update with nonexisting files and --all creates and appends each" {
    run addOrAppendAssignment --create-nonexisting --all --in-place --lhs foo --rhs new "$NONE" "$FILE" "$NONE2" "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ -e "$NONE" ]
    [ -e "$NONE2" ]
    [ "$(cat "$NONE")" = 'foo="new"' ]
    [ "$(cat "$NONE2")" = 'foo="new"' ]
    [ "$(cat "$FILE")" = 'sing/e="wha\ever"
foo="bar new"
foo="hoo bar baz"
# SECTION
fox="hi there"' ]
    [ "$(cat "$FILE2")" = 'foo="bar new"
quux="initial value"
fox=
foy=""' ]
}

@test "update with all nonexisting files and --all creates and appends to each" {
    run addOrAppendAssignment --create-nonexisting --all --in-place --lhs new --rhs add "$NONE" "$NONE2"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ -e "$NONE" ]
    [ -e "$NONE2" ]
    [ "$(cat "$NONE")" = 'new="add"' ]
    [ "$(cat "$NONE2")" = 'new="add"' ]
}
