#!/usr/bin/env bats

load temp

pipedContainedOrAddOrUpdateAssignment()
{
    local input="$1"; shift
    printf '%s\n' "$input" | containedOrUpdateAssignment "$@"
}

@test "returns 1 and no output if implicit stdin already contains the line" {
    init
    INPUT="SOME line
foo=bar
more"
    export MEMOIZEDECISION_CHOICE=n
    run pipedContainedOrAddOrUpdateAssignment "$INPUT" --lhs foo --rhs bar
    [ $status -eq 1 ]
    [[ "$output" =~ " does not match or already contains 'foo=bar'; no update possible / necessary."$ ]]
}

@test "returns 1 and no output if stdin as - already contains the line" {
    init
    INPUT="Some line
foo=bar
more"
    export MEMOIZEDECISION_CHOICE=n
    run pipedContainedOrAddOrUpdateAssignment "$INPUT" --lhs foo --rhs bar -
    [ $status -eq 1 ]
    [[ "$output" =~ " does not match or already contains 'foo=bar'; no update possible / necessary."$ ]]
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

