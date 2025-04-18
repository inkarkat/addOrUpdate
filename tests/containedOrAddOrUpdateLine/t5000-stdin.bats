#!/usr/bin/env bats

load temp

@test "returns 99 and no output if implicit stdin already contains the line" {
    INPUT='SOME line
foo=bar
more'
    export MEMOIZEDECISION_CHOICE=n
    run -99 containedOrAddOrUpdateLine --line "foo=bar" <<<"$INPUT"
    assert_output -e " already contains 'foo=bar'; no update necessary\\.\$"
}

@test "returns 99 and no output if stdin as - already contains the line" {
    INPUT='Some line
foo=bar
more'
    export MEMOIZEDECISION_CHOICE=n
    run -99 containedOrAddOrUpdateLine --line "foo=bar" - <<<"$INPUT"
    assert_output -e " already contains 'foo=bar'; no update necessary\\.\$"
}

@test "asks and returns 98 and no output if the update is declined by the user" {
    INPUT='foo=bar'
    UPDATE='foo=new'
    export MEMOIZEDECISION_CHOICE=n
    run -98 containedOrAddOrUpdateLine --line "$UPDATE" - <<<"$INPUT"
    assert_output -p "does not yet contain '$UPDATE'. Shall I update it?"
}

@test "asks, appends, returns 0, and prints output if the update is accepted by the user" {
    INPUT='Some line
foo=bar'
    UPDATE='foo=new'
    export MEMOIZEDECISION_CHOICE=y
    run -0 containedOrAddOrUpdateLine --update-match "foo=b" --line "$UPDATE" - <<<"$INPUT"
    assert_line -n 0 -p "does not yet contain '$UPDATE'. Shall I update it?"
    assert_line -n 1 'Some line'
    assert_line -n 2 "$UPDATE"
}
