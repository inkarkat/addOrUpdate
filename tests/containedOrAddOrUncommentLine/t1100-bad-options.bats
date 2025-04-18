#!/usr/bin/env bats

load fixture
load temp

@test "error when no LINE passed" {
    run -2 containedOrAddOrUncommentLine "$FILE"
    assert_line -n 0 'ERROR: No LINE passed.'
    assert_line -n 1 -e '^Usage:'
}

@test "error when both comment prefix and suffix are empty" {
    run -2 containedOrAddOrUncommentLine --comment-prefix '' --comment-suffix '' --line new "$FILE"
    [ "${lines[0]}" = "ERROR: -c|--comment-prefix and -C|--comment-suffix cannot both be empty." ]
    assert_line -n 1 -e '^Usage:'
}
