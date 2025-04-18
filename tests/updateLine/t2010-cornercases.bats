#!/usr/bin/env bats

load temp

@test "update with existing last line keeps contents and returns 99" {
    run -99 updateLine --update-match "foo=hi" --replacement '&' "$FILE"
    assert_output - < "$INPUT"
}

@test "in-place update with existing last line keeps contents and returns 99" {
    run -99 updateLine --in-place --update-match "foo=hi" --replacement '&' "$FILE"
    assert_output ''
    diff -y "$INPUT" "$FILE"
}

@test "update with existing line on the add-before line keeps contents and returns 99" {
    run -99 updateLine --update-match "foo=hoo bar baz" --replacement '&' --add-before 3 "$FILE"
    assert_output - < "$INPUT"
}

@test "update with existing line on the add-after line keeps contents and returns 99" {
    run -99 updateLine --update-match "foo=hoo bar baz" --replacement '&' --add-after 3 "$FILE"
    assert_output - < "$INPUT"
}

@test "in-place update with existing line on the add-before line keeps contents and returns 99" {
    run -99 updateLine --in-place --update-match "foo=hoo bar baz" --replacement '&' --add-before 3 "$FILE"
    assert_output ''
    diff -y "$INPUT" "$FILE"
}

@test "in-place update with existing line on the add-after line keeps contents and returns 99" {
    run -99 updateLine --in-place --update-match "foo=hoo bar baz" --replacement '&' --add-after 3 "$FILE"
    assert_output ''
    diff -y "$INPUT" "$FILE"
}
