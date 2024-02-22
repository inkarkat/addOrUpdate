#!/usr/bin/env bats

load temp

@test "update in first file skips following files" {
    addOrUpdateWithSed --in-place $SED_UPDATE -- "$FILE" "$FILE2" "$FILE3"
    [ "$(cat "$FILE")" = "updated
foo=bar
foo=hoo bar baz
# SECTION
foo=hi" ]
    cmp "$FILE2" "$MORE2"
    cmp "$FILE3" "$MORE3"
}

@test "update in second file skips previous and following files" {
    addOrUpdateWithSed --in-place -e '/^\(quux\|zulu\)=/{ h; s/=.*/=updated/ }' -e '${ x; /^$/{ x; q99 }; x }' -- "$FILE" "$FILE2" "$FILE3"
    cmp "$FILE" "$INPUT"
    [ "$(cat "$FILE2")" = "foo=bar
quux=updated
foo=moo bar baz" ]
    cmp "$FILE3" "$MORE3"
}

@test "alternative update in second file skips previous and following files" {
    addOrUpdateWithSed --in-place -e 's/^quux=.*/quux=updated/; T end; h' -e ':end' -e '${ x; /^$/{ x; q99 }; x }' -- "$FILE" "$FILE2" "$FILE3"
    cmp "$FILE" "$INPUT"
    [ "$(cat "$FILE2")" = "foo=bar
quux=updated
foo=moo bar baz" ]
    cmp "$FILE3" "$MORE3"
}

@test "update with no modification in all files keeps contents and returns 99" {
    run addOrUpdateWithSed --in-place $SED_NO_MOD -- "$FILE" "$FILE2" "$FILE3"
    [ $status -eq 99 ]
    cmp "$FILE" "$INPUT"
    cmp "$FILE2" "$MORE2"
    cmp "$FILE3" "$MORE3"
}
