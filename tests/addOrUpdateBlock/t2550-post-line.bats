#!/usr/bin/env bats

load temp

@test "append with one post line" {
    POSTLINE="# new footer"
    run addOrUpdateBlock --post-line "$POSTLINE" --marker test --block-text "$TEXT" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "$(cat "$FRESH")
$BLOCK
$POSTLINE" ]
}

@test "append with three separate post lines" {
    POSTLINE1="# first footer"
    POSTLINE2=''
    POSTLINE3="# third footer"
    run addOrUpdateBlock --post-line "$POSTLINE1" --post-line "$POSTLINE2" --post-line "$POSTLINE3" --marker test --block-text "$TEXT" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "$(cat "$FRESH")
$BLOCK
$POSTLINE1
$POSTLINE2
$POSTLINE3" ]
}

@test "append with one multi-line post line" {
    POSTLINE="# first footer

# third footer"
    POSTLINE1="# first footer"
    POSTLINE2=''
    POSTLINE3="# third footer"
    run addOrUpdateBlock --post-line "$POSTLINE" --marker test --block-text "$TEXT" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "$(cat "$FRESH")
$BLOCK
$POSTLINE1
$POSTLINE2
$POSTLINE3" ]
}

addOrUpdateLineWithPeriod()
{
    addOrUpdateBlock "$@"; printf .
}

@test "empty post line" {
    run addOrUpdateLineWithPeriod --post-line '' --marker test --block-text "$TEXT" "$FILE"
    [ $status -eq 0 ]
    [ "${output}" = "$(cat "$FRESH")
$BLOCK

." ]
}

@test "empty and non-empty post lines" {
    run addOrUpdateLineWithPeriod --post-line '' --post-line "$POSTLINE" --marker test --block-text "$TEXT" "$FILE"
    [ $status -eq 0 ]
    [ "${output}" = "$(cat "$FRESH")
$BLOCK

$POSTLINE
." ]
}

@test "non-empty and empty post lines" {
    run addOrUpdateLineWithPeriod --post-line "$POSTLINE" --post-line '' --marker test --block-text "$TEXT" "$FILE"
    [ $status -eq 0 ]
    [ "${output}" = "$(cat "$FRESH")
$BLOCK
$POSTLINE

." ]
}

@test "single space post line" {
    POSTLINE=" "
    run addOrUpdateLineWithPeriod --post-line "$POSTLINE" --marker test --block-text "$TEXT" "$FILE"
    [ $status -eq 0 ]
    [ "${output}" = "$(cat "$FRESH")
$BLOCK
${POSTLINE}
." ]
}
