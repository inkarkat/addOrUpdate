#!/usr/bin/env bats

load temp

@test "update all updates all files" {
    addOrUpdateWithSed --all --in-place $SED_UPDATE -- "$FILE" "$FILE2" "$FILE3"
    [ "$(cat "$FILE")" = "updated
foo=bar
foo=hoo bar baz
# SECTION
foo=hi" ]
    [ "$(cat "$FILE2")" = "updated
quux=initial
foo=moo bar baz" ]
    [ "$(cat "$FILE3")" = "updated
foo=bar
foo=no bar baz" ]
}

@test "update all with match in second and third files" {
    addOrUpdateWithSed --all --in-place -e '/^\(quux\|zulu\)=/{ h; s/=.*/=updated/ }' -e '${ x; /^$/{ x; q99 }; x }' -- "$FILE" "$FILE2" "$FILE3"
    cmp "$INPUT" "$FILE"
    [ "$(cat "$FILE2")" = "foo=bar
quux=updated
foo=moo bar baz" ]
    [ "$(cat "$FILE3")" = "zulu=updated
foo=bar
foo=no bar baz" ]
}

@test "update all with no modification in all files keeps contents and returns 1" {
    run addOrUpdateWithSed --all --in-place $SED_NO_MOD -- "$FILE" "$FILE2" "$FILE3"
    [ $status -eq 1 ]
    cmp "$FILE" "$INPUT"
    cmp "$FILE2" "$MORE2"
    cmp "$FILE3" "$MORE3"
}

