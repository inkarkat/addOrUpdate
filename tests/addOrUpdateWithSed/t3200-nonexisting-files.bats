#!/usr/bin/env bats

load temp

@test "processing standard input works" {
    CONTENTS="# useless
stuff"
    output="$(echo "$CONTENTS" | addOrUpdateWithSed $SED_UPDATE)"
    [ "$output" = "updated
stuff" ]
}

@test "nonexisting file and standard input works" {
    CONTENTS="# useless
stuff"
    output="$(echo "$CONTENTS" | addOrUpdateWithSed $SED_UPDATE -- "$NONE" -)"
    [ "$output" = "updated
stuff" ]
}

@test "update in first existing file skips nonexisting files" {
    run addOrUpdateWithSed --in-place $SED_UPDATE -- "$NONE" "$FILE" "$NONE2" "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ "$(cat "$FILE")" = "updated
foo=bar
foo=hoo bar baz
# SECTION
foo=hi" ]
    cmp "$FILE2" "$MORE2"
    [ ! -e "$NONE" ]
    [ ! -e "$NONE2" ]
}

@test "all nonexisting files returns 4" {
    run addOrUpdateWithSed --in-place $SED_UPDATE -- "$NONE" "$NONE2"
    [ $status -eq 4 ]
    [ "$output" = "" ]
    [ ! -e "$NONE" ]
    [ ! -e "$NONE2" ]
}
