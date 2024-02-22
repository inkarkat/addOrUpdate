#!/usr/bin/env bats

load temp

pipedContainedOrAddOrUpdateBlock()
{
    local input="$1"; shift
    printf '%s\n' "$input" | containedOrAddOrUpdateBlock "$@"
}

@test "returns 98 and no output if implicit stdin already contains the block" {
    export MEMOIZEDECISION_CHOICE=n
    run pipedContainedOrAddOrUpdateBlock "$BLOCK" --marker test --block-text "$TEXT"
    [ $status -eq 98 ]
    [[ "$output" =~ " already contains test; no update necessary."$ ]]
}

@test "returns 98 and no output if stdin as - already contains the block" {
    export MEMOIZEDECISION_CHOICE=n
    run pipedContainedOrAddOrUpdateBlock "$BLOCK" --marker test --block-text "$TEXT" -
    [ $status -eq 98 ]
    [[ "$output" =~ " already contains test; no update necessary."$ ]]
}

@test "asks and returns 99 and no output if the update is declined by the user" {
    export MEMOIZEDECISION_CHOICE=n
    run pipedContainedOrAddOrUpdateBlock "$BLOCK" --marker test --block-text new -
    [ $status -eq 99 ]
    [[ "$output" =~ does\ not\ yet\ contain\ test\.\ Shall\ I\ update\ it\? ]]
}

@test "asks, appends, returns 0, and prints output if the update is accepted by the user" {
    export MEMOIZEDECISION_CHOICE=y
    run pipedContainedOrAddOrUpdateBlock "$BLOCK" --marker test --block-text new -
    [ $status -eq 0 ]
    [[ "${lines[0]}" =~ does\ not\ yet\ contain\ test\.\ Shall\ I\ update\ it\? ]]
    IFS=$'\n'
    [ "${lines[*]:1}" = "# BEGIN test
new
# END test" ]
}
