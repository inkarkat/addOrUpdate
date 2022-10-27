#!/usr/bin/env bats

load temp

@test "append with one pre line" {
    PRELINE="# new header"
    run addOrUpdateBlock --pre-line "$PRELINE" --marker test --block-text "$TEXT" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "$(cat "$FRESH")
$PRELINE
$BLOCK" ]
}

@test "append with three separate pre lines" {
    PRELINE1="# first header"
    PRELINE2=''
    PRELINE3="# third header"
    run addOrUpdateBlock --pre-line "$PRELINE1" --pre-line "$PRELINE2" --pre-line "$PRELINE3" --marker test --block-text "$TEXT" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "$(cat "$FRESH")
$PRELINE1
$PRELINE2
$PRELINE3
$BLOCK" ]
}

@test "append with one multi-line pre line" {
    PRELINE="# first header

# third header"
    PRELINE1="# first header"
    PRELINE2=''
    PRELINE3="# third header"
    run addOrUpdateBlock --pre-line "$PRELINE" --marker test --block-text "$TEXT" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "$(cat "$FRESH")
$PRELINE1
$PRELINE2
$PRELINE3
$BLOCK" ]
}

@test "empty pre line" {
    run addOrUpdateBlock --pre-line '' --marker test --block-text "$TEXT" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "$(cat "$FRESH")

$BLOCK" ]
}

@test "empty and non-empty pre lines" {
    run addOrUpdateBlock --pre-line '' --pre-line "$PRELINE" --marker test --block-text "$TEXT" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "$(cat "$FRESH")

$PRELINE
$BLOCK" ]
}

@test "non-empty and empty pre lines" {
    run addOrUpdateBlock --pre-line "$PRELINE" --pre-line '' --marker test --block-text "$TEXT" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "$(cat "$FRESH")
$PRELINE

$BLOCK" ]
}

@test "single space pre line" {
    PRELINE=" "
    run addOrUpdateBlock --pre-line "$PRELINE" --marker test --block-text "$TEXT" "$FILE"
    [ $status -eq 0 ]
    [ "$output" = "$(cat "$FRESH")
$PRELINE
$BLOCK" ]
}
