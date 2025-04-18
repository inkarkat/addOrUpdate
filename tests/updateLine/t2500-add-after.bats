#!/usr/bin/env bats

load temp

@test "update with existing line after the passed line keeps contents and returns 1" {
    run -1 updateLine --update-match "foo=h.*" --replacement '&&' --add-after 1 "$FILE"
    assert_output - < "$INPUT"
}
