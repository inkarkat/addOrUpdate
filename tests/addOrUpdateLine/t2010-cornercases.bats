#!/usr/bin/env bats

load temp

@test "update with existing last line keeps contents and returns 99" {
    run -99 addOrUpdateLine --line "foo=hi" "$FILE"
    assert_output - < "$INPUT"
}

@test "in-place update with existing last line keeps contents and returns 99" {
    run -99 addOrUpdateLine --in-place --line "foo=hi" "$FILE"
    assert_output ''
    diff -y "$INPUT" "$FILE"
}

@test "update with existing line on the add-before line keeps contents and returns 99" {
    run -99 addOrUpdateLine --line "foo=hoo bar baz" --add-before 3 "$FILE"
    assert_output - < "$INPUT"
}

@test "update with existing line on the add-after line keeps contents and returns 99" {
    run -99 addOrUpdateLine --line "foo=hoo bar baz" --add-after 3 "$FILE"
    assert_output - < "$INPUT"
}

@test "in-place update with existing line on the add-before line keeps contents and returns 99" {
    run -99 addOrUpdateLine --in-place --line "foo=hoo bar baz" --add-before 3 "$FILE"
    assert_output ''
    diff -y "$INPUT" "$FILE"
}

@test "in-place update with existing line on the add-after line keeps contents and returns 99" {
    run -99 addOrUpdateLine --in-place --line "foo=hoo bar baz" --add-after 3 "$FILE"
    assert_output ''
    diff -y "$INPUT" "$FILE"
}
