#!/usr/bin/env bats

load temp

@test "update with nonexisting first file creates and uses that as last" {
    run addOrUpdateWithSed --create-nonexisting --in-place --last-file $'$a\\\nnew=got added' --last-file '$q' $SED_UPDATE -- "$NONE" "$FILE" "$NONE2" "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ -e "$NONE" ]
    [ "$(cat "$NONE")" = "
new=got added" ]
    cmp "$FILE" "$INPUT"
    cmp "$FILE2" "$MORE2"
    [ ! -e "$NONE2" ]
}

@test "update with all nonexisting files creates and inserts as last in the first one" {
    run addOrUpdateWithSed --create-nonexisting --last-file $'$a\\\nnew=got added' --last-file '$q' --in-place $SED_UPDATE -- "$NONE" "$NONE2"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ -e "$NONE" ]
    [ "$(cat "$NONE")" = "
new=got added" ]
    [ ! -e "$NONE2" ]
}

@test "update with nonexisting files and --all creates and inserts as last in each" {
    run addOrUpdateWithSed --create-nonexisting --all --in-place --last-file $'$a\\\nnew=got added' --last-file '$q' $SED_UPDATE -- "$NONE" "$FILE" "$NONE2" "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ -e "$NONE" ]
    [ -e "$NONE2" ]
    [ "$(cat "$NONE")" = "
new=got added" ]
    [ "$(cat "$NONE2")" = "
new=got added" ]
    [ "$(cat "$FILE")" = "updated
foo=bar
foo=hoo bar baz
# SECTION
foo=hi
new=got added" ]
    [ "$(cat "$FILE2")" = "updated
quux=initial
foo=moo bar baz
new=got added" ]
}

@test "update with all nonexisting files and --all creates and inserts as last in each" {
    run addOrUpdateWithSed --create-nonexisting --all --in-place --last-file $'$a\\\nnew=got added' --last-file '$q' $SED_UPDATE -- "$NONE" "$NONE2"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ -e "$NONE" ]
    [ -e "$NONE2" ]
    [ "$(cat "$NONE")" = "
new=got added" ]
    [ "$(cat "$NONE2")" = "
new=got added" ]
}
