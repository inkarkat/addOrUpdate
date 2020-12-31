#!/usr/bin/env bats

load temp

@test "processing standard input works" {
    output="$(echo "$CONTENTS" | addOrUpdateBlock --marker test --block-text "$TEXT")"
    [ "$output" = "$CONTENTS
$BLOCK" ]
}

@test "nonexisting file and standard input works" {
    output="$(echo "$CONTENTS" | addOrUpdateBlock --marker test --block-text "$TEXT" "$NONE" -)"
    [ "$output" = "$CONTENTS
$BLOCK" ]
}

@test "update in first existing file skips nonexisting files" {
    run addOrUpdateBlock --in-place --marker test --block-text "$TEXT" "$NONE" "$FILE3" "$NONE2" "$FILE2"
    [ $status -eq 0 ]
    [ "$output" = "" ]
    [ "$(cat "$FILE3")" = "# BEGIN test
$TEXT
# END test" ]
    cmp "$FILE2" "$EXISTING"
    [ ! -e "$NONE" ]
    [ ! -e "$NONE2" ]
}

@test "all nonexisting files returns 4" {
    run addOrUpdateBlock --in-place --marker test --block-text "$TEXT" "$NONE" "$NONE2"
    [ $status -eq 4 ]
    [ "$output" = "" ]
    [ ! -e "$NONE" ]
    [ ! -e "$NONE2" ]
}
