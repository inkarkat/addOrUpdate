#!/usr/bin/env bats

load temp

@test "returns 99 and no output if implicit stdin already contains the line" {
    INPUT='SOME line
some data
more'
    export MEMOIZEDECISION_CHOICE=n
    run -99 containedOrAddOrUncommentLine --line 'some data' <<<"$INPUT"
    assert_output -e " already contains 'some data'; no update necessary."$
}

@test "returns 99 and no output if stdin as - already contains the line" {
    INPUT='Some line
some data
more'
    export MEMOIZEDECISION_CHOICE=n
    run -99 containedOrAddOrUncommentLine --line 'some data' - <<<"$INPUT"
    assert_output -e " already contains 'some data'; no update necessary."$
}

@test "asks and returns 98 and no output if the update is declined by the user" {
    INPUT='some data'
    UPDATE='new'
    export MEMOIZEDECISION_CHOICE=n
    run -98 containedOrAddOrUncommentLine --line new - <<<"$INPUT"
    assert_output -e "does not yet contain '$UPDATE'. Shall I update it?"
}
