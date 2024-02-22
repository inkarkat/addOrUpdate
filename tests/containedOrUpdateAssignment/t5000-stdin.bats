#!/usr/bin/env bats

load temp

pipedContainedOrAddOrUpdateAssignment()
{
    local input="$1"; shift
    printf '%s\n' "$input" | containedOrUpdateAssignment "$@"
}

@test "returns 99 and no output if implicit stdin already contains the line" {
    init
    INPUT="SOME line
foo=bar
more"
    export MEMOIZEDECISION_CHOICE=n
    run pipedContainedOrAddOrUpdateAssignment "$INPUT" --lhs foo --rhs bar
    [ $status -eq 99 ]
    [[ "$output" =~ " already contains 'foo=bar'; no update necessary."$ ]]
}

@test "returns 99 and no output if stdin as - already contains the line" {
    init
    INPUT="Some line
foo=bar
more"
    export MEMOIZEDECISION_CHOICE=n
    run pipedContainedOrAddOrUpdateAssignment "$INPUT" --lhs foo --rhs bar -
    [ $status -eq 99 ]
    [[ "$output" =~ " already contains 'foo=bar'; no update necessary."$ ]]
}

@test "asks and returns 98 and no output if the update is declined by the user" {
    init
    INPUT="foo=bar"
    UPDATE="foo=new"
    export MEMOIZEDECISION_CHOICE=n
    run pipedContainedOrAddOrUpdateAssignment "$INPUT" --lhs foo --rhs new -
    [ $status -eq 98 ]
    [[ "$output" =~ does\ not\ yet\ contain\ \'$UPDATE\'\.\ Shall\ I\ update\ it\? ]]
}

