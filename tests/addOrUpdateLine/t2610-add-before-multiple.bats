#!/usr/bin/env bats

load temp

@test "update with existing line one after the passed line skips early to do the update in the second file and ignores the existing later line" {
    run addOrUpdateLine --in-place --line "foo=updated" --update-match "foo=b.*" --add-before 1 "$FILE" "$FILE2"
    [ $status -eq 0 ]
    cmp "$FILE" "$INPUT"
    [ "$(cat "$FILE2")" = "foo=updated
quux=initial
foo=moo bar baz" ]
}
