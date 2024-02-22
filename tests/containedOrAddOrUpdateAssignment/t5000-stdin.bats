#!/usr/bin/env bats

load temp

pipedContainedOrAddOrUpdateAssignment()
{
    local input="$1"; shift
    printf '%s\n' "$input" | containedOrAddOrUpdateAssignment "$@"
}

@test "returns 98 and no output if implicit stdin already contains the line" {
    init
    INPUT="SOME line
foo=bar
more"
    export MEMOIZEDECISION_CHOICE=n
    run pipedContainedOrAddOrUpdateAssignment "$INPUT" --lhs foo --rhs bar
    [ $status -eq 98 ]
    [[ "$output" =~ " already contains 'foo=bar'; no update necessary."$ ]]
}

@test "returns 98 and no output if stdin as - already contains the line" {
    init
    INPUT="Some line
foo=bar
more"
    export MEMOIZEDECISION_CHOICE=n
    run pipedContainedOrAddOrUpdateAssignment "$INPUT" --lhs foo --rhs bar -
    [ $status -eq 98 ]
    [[ "$output" =~ " already contains 'foo=bar'; no update necessary."$ ]]
}

@test "asks and returns 99 and no output if the update is declined by the user" {
    init
    INPUT="foo=bar"
    UPDATE="foo=new"
    export MEMOIZEDECISION_CHOICE=n
    run pipedContainedOrAddOrUpdateAssignment "$INPUT" --lhs foo --rhs new -
    [ $status -eq 99 ]
    [[ "$output" =~ does\ not\ yet\ contain\ \'$UPDATE\'\.\ Shall\ I\ update\ it\? ]]
}

@test "asks, appends, returns 0, and prints output if the update is accepted by the user" {
    init
    INPUT="Some line
foo=bar"
    UPDATE="foo=new"
    export MEMOIZEDECISION_CHOICE=y
    run pipedContainedOrAddOrUpdateAssignment "$INPUT" --update-match "foo=b" --lhs foo --rhs new -
    [ $status -eq 0 ]
    [[ "${lines[0]}" =~ does\ not\ yet\ contain\ \'$UPDATE\'\.\ Shall\ I\ update\ it\? ]]
    [ "${lines[1]}" = "Some line" ]
    [ "${lines[2]}" = "$UPDATE" ]
}
