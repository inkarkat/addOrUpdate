#!/usr/bin/env bats

load temp

@test "update in first file skips last file program and following files" {
    addOrUpdateWithSed --in-place --last-file $'$a\\\nnew=got added' --last-file '$q' $SED_UPDATE -- "$FILE" "$FILE2" "$FILE3"
    [ "$(cat "$FILE")" = "updated
foo=bar
foo=hoo bar baz
# SECTION
foo=hi" ]
    cmp "$FILE2" "$MORE2"
    cmp "$FILE3" "$MORE3"
}

@test "update with no modification runs last file program on the last file" {
    run addOrUpdateWithSed --in-place --last-file $'$a\\\nnew=got added' --last-file '$q' $SED_NO_MOD -- "$FILE" "$FILE2" "$FILE3"
    [ $status -eq 0 ]
    cmp "$FILE" "$INPUT"
    cmp "$FILE2" "$MORE2"
    [ "$(cat "$FILE3")" = "zulu=here
foo=bar
foo=no bar baz
new=got added" ]
}

@test "update all with no modification runs last file program on all files" {
    run addOrUpdateWithSed --all --in-place --last-file $'$a\\\nnew=got added' --last-file '$q' $SED_NO_MOD -- "$FILE" "$FILE2" "$FILE3"
    [ $status -eq 0 ]
    [ "$(cat "$FILE")" = 'sing/e=wha\ever
foo=bar
foo=hoo bar baz
# SECTION
foo=hi
new=got added' ]
    [ "$(cat "$FILE2")" = 'foo=bar
quux=initial
foo=moo bar baz
new=got added' ]
    [ "$(cat "$FILE3")" = 'zulu=here
foo=bar
foo=no bar baz
new=got added' ]
}
